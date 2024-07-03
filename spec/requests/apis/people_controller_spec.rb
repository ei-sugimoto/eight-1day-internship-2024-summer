# frozen_string_literal: true

require Rails.root.join('spec/db_card_shared_context').to_s

describe Apis::PeopleController, type: :request do
  describe '#index' do
    subject(:call_api) { get apis_people_path, params: }

    let(:params) { {} }

    include_context 'db_card'

    it { is_expected.to eq 200 }

    it 'ID降順で5件の人物データが取得できること' do
      call_api
      expect(JSON.parse(response.body)).to match(
        [include({ 'id' => 20 }), include({ 'id' => 19 }), include({ 'id' => 18 }), include({ 'id' => 17 }),
         include({ 'id' => 16 })],
      )
    end

    it '人物データのフォーマットがAPI定義通り出力できていること' do
      call_api
      expect(JSON.parse(response.body).first).to match(
        { 'cards' => [{ 'id' => instance_of(Integer), 'name' => '西 顕太郎', 'organization' => '株式会社ピクルス' }],
          'id' => 20, 'memo' => include('新機能の実装に向けて技術調査中') },
      )
    end

    context 'strict_loading!' do
      prepend_before do
        @current_strict_loading_by_default = ApplicationRecord.strict_loading_by_default
        ApplicationRecord.strict_loading_by_default = true
      end

      after do
        ApplicationRecord.strict_loading_by_default = @current_strict_loading_by_default # rubocop:disable RSpec/InstanceVariable
      end

      it 'N+1による例外が発生しないこと' do
        expect { call_api }.not_to raise_error
      end
    end

    context '名前での検索' do
      let(:params) { { query: '久保' } }

      it '該当する人物データを取得できること' do
        call_api
        expect(JSON.parse(response.body)).to match([include({ 'id' => 16 })])
      end
    end

    context 'メールアドレスでの検索' do
      let(:params) { { query: 'isibasi@example' } }

      it '該当する人物データを取得できること' do
        call_api
        expect(JSON.parse(response.body)).to match([include({ 'id' => 14 })])
      end
    end

    context '会社名での検索' do
      let(:params) { { query: '会社たく' } }

      it '該当する人物データを取得できること' do
        call_api
        expect(JSON.parse(response.body)).to match([include({ 'id' => 15 })])
      end
    end

    context 'ワイルドカード検索のサニタイズ' do
      let(:params) { { query: '%' } }

      before do
        Person.find(16).cards.first.update!(name: '大久保%美砂')
      end

      it '該当する人物データを取得できること' do
        call_api
        expect(JSON.parse(response.body)).to match([include({ 'id' => 16 })])
      end
    end

    context 'SQLインジェクション対策' do
      let(:params) { { query: "' OR '1'='1" } }

      it '人物データを取得できないこと' do
        call_api
        expect(JSON.parse(response.body)).to eq([])
      end
    end
  end
end
