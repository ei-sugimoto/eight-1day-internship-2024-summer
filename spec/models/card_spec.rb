# == Schema Information
#
# Table name: cards
#
#  id           :bigint           not null, primary key
#  department   :string(255)
#  email        :string(255)
#  name         :string(255)
#  organization :string(255)
#  title        :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  person_id    :bigint           not null
#
# Indexes
#
#  index_cards_on_email         (email)
#  index_cards_on_name          (name)
#  index_cards_on_organization  (organization)
#  index_cards_on_person_id     (person_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#

require Rails.root.join('spec/db_card_shared_context').to_s

describe Card do
  describe '#register' do
    subject { described_class.new(params).register }

    include_context 'db_card'

    # '谷川 貞久'はperson_id: 7のcardとnameとemailが一致しているため、person_id: 7にmergeされる
    context '谷川 貞久の場合' do
      let(:params) do
        {
          name: '谷川 貞久',
          email: 'awakinat1981@example.com',
          organization: 'とまと株式会社',
          department: '開発部',
          title: 'サーバーサイドエンジニア',
        }
      end

      it 'person_id: 17に紐づく名刺が2枚あること' do
        subject
        expect(described_class.where(person_id: 17).size).to eq(2)
      end
    end

    # '大平 美里'はmerge条件に一致しないため、新規にpersonが作成される
    context '大平 美里の場合' do
      let(:params) do
        {
          name: '大平 美里',
          email: 'tsm198320010406@example.com',
          organization: 'とうがらし株式会社',
          department: '人事部',
          title: '人事',
        }
      end

      it 'ユーザが新規作成されること' do
        expect { subject }.to change(Person, :count).from(20).to(21)
      end
    end

    # '東 顕太郎'はperson_id: 10のcardとemailが一致しており、
    # 役職スコアが80を超えているため、person_id: 10にmergeされる
    context '東 顕太郎の場合' do
      let(:params) do
        {
          name: '東 顕太郎',
          email: 'nishi@example.com',
          organization: '株式会社ピクルス',
          department: '開発部',
          title: 'サーバーサイドエンジニア',
        }
      end

      it 'person_id: 20に紐づく名刺が2枚あること' do
        subject
        expect(described_class.where(person_id: 20).size).to eq(2)
      end
    end

    # メールアドレス一致のみで title スコアが80を超えないため、新規にpersonが作成される
    context '橋本 遥希の場合' do
      let(:params) do
        {
          name: '橋本 遥希',
          email: 'yazima2006@example.com',
          organization: '株式会社ピクルス',
          department: '開発部',
          title: 'サーバーサイドエンジニア',
        }
      end
      let(:cards_bucket) do
        Aws::S3::Resource.new(Rails.configuration.s3.credentials).bucket(Rails.configuration.s3.buckets[:cards])
      end

      before { cards_bucket.clear! }

      it '新しい Person が作られること' do
        expect { subject }.to change(Person, :count).from(20).to(21)
      end

      it '名刺画像がS3にアップロードされること' do
        expect { subject }.to change { cards_bucket.objects.count }.by(1)
      end
    end
  end
end
