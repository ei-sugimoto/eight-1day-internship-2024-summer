# rbs_inline: enabled

module S3Usable
  extend ActiveSupport::Concern

  def s3_bucket_base(bucket_name)
    bucket = s3_resource.bucket(bucket_name)
    bucket.exists? ? bucket : s3_resource.create_bucket(bucket: bucket_name)
  end

  def s3_resource
    @s3_resource ||= Aws::S3::Resource.new(Rails.configuration.s3.credentials)
  end
end
