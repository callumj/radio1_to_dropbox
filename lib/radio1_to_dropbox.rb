require 'radio1_to_dropbox/tools'

module Radio1ToDropbox

  def self.s3_instance
    @s3 ||= AWS::S3.new
  end

  def self.s3_bucket
    s3_instance.buckets[ENV["S3_BUCKET"]]
  end

end
