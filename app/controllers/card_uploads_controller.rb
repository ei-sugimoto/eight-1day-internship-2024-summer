class CardUploadsController < ApplicationController
  include S3Usable

  BUCKET_NAME = Rails.configuration.s3.buckets[:card_uploads]

  # Rails_Q3: Webアプリで名刺の取り込みをしよう
  def new; end

  def create
    head :created
  end

  private

  def card_csv
    params.require(:card_csv)
  end
end
