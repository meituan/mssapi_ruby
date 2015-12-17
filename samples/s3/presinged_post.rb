require 'aws-sdk-v1'
require 'rest-client'

(access_key, secret_key, bucket_name, object_key, file_name, callback_url) = ARGV
unless access_key && secret_key && bucket_name && object_key && file_name && callback_url
  puts "Usage: presigned_pose.rb <ACCESS_KEY> <SECRET_KEY> <BUCKET_NAME> <OBJECT_KEY> <FILE_NAME> <CALLBACK_URL>"
  exit 1
end

# Server End
s3 = AWS::S3.new({
    :s3_endpoint => 'mtmss.com',
    :use_ssl => false,
    :s3_force_path_style => true,
    :access_key_id => access_key,
    :secret_access_key => secret_key})

post_info_str = s3.presigned_post_info(
    bucket_name, #bucket name
    {
      :expires => 3600,
      :metadata => {"x-amz-meta-server" => "Hello Server!"}, # custom defined variables, must with prefix "x-amz-meta-"
      :callback_url => callback_url,
      :callback_body => "name=${fname}&bucket=${bucket}&key=${key}&hash=${etag}&size=${fsize}&server=${x-amz-meta-server}&client=${x-amz-meta-client}",
      :callback_body_type => "application/x-www-form-urlencoded",
    }).to_json

# Client End
client_info = {
  "x-amz-meta-client" => "Hello Client!",
  "key" => object_key,
  "value" => File.new(file_name, 'rb'),
}

post_info_obj = JSON.parse(post_info_str)
puts post_info_obj["form"].merge(client_info)
RestClient.post post_info_obj["url"], post_info_obj["form"].merge(client_info)

