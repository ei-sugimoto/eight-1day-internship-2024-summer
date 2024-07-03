# frozen_string_literal: true

require Rails.root.join('spec/db_card_shared_context').to_s

describe CardUploadsController, type: :request do
  describe '#new' do
    subject(:call_api) { get new_card_uploads_path }

    it { is_expected.to eq 200 }
  end

  describe '#create' do
    subject(:call_api) { post card_uploads_path, params: }

    let(:params) { { card_csv: Rack::Test::UploadedFile.new(Rails.root.join('db/additional_cards.csv')) } }
    let(:card_uploads_bucket) do
      Aws::S3::Resource.new(Rails.configuration.s3.credentials).bucket(Rails.configuration.s3.buckets[:card_uploads])
    end

    before { card_uploads_bucket.clear! }

    include_context 'db_card'

    context '複数回実行' do
      before { post card_uploads_path, params: }

      it 'key重複せずS3にアップロードできること' do
        expect { call_api }.to change { card_uploads_bucket.objects.count }.from(1).to(2)
      end
    end

    it '非同期ジョブがエンキューされていること' do
      expect { call_api }.to change { ApplicationJob.queue_adapter.enqueued_jobs.count }.by(1)
    end

    it '名刺登録されていないこと' do
      expect { call_api }.not_to change(Person, :count).from(20)
    end

    context '非同期ジョブを同期実行' do
      it '名刺登録されていること' do
        perform_enqueued_jobs do
          expect { call_api }.to change(Person, :count).by(1)
        end
      end

      it '名寄せされていること' do
        perform_enqueued_jobs do
          expect { call_api }.to change { Card.where(person_id: 20).count }.from(1).to(2)
        end
      end
    end
  end
end
