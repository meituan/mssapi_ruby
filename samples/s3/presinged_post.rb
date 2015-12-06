require 'aws-sdk-v1'
require 'rest-client'

# Server End
s3 = AWS::S3.new({
    :s3_endpoint => '192.168.12.221',
    :use_ssl => false,
    :s3_force_path_style => true,
    :access_key_id => 'c940750fabf04b9196597bf1e77eea44',
    :secret_access_key => 'eb619acf85a84641b694b4733967918e'})

post_info_str = s3.presigned_post_info(
    "form", #bucket name
    {
      :metadata => {"x-amz-meta-server" => "Hello Server!"}, # custom defined variables, must with prefix "x-amz-meta-"
      :callback_url => "http://192.168.12.159:9999",
      :callback_body => "name=${fname}&bucket=${bucket}&key=${key}&hash=${etag}&size=${fsize}&server=${x-amz-meta-server}&client=${x-amz-meta-client}",
      :callback_body_type => "application/x-www-form-urlencoded",
      :callback_host => "192.168.12.159"
    }).to_json


# Client End
client_info = {
  :key => "lena.jpg",
  :value => File.new("/home/yubai/share/pic/lena.jpg", 'rb'),
  "x-amz-meta-client" => "Hello Client!"
}

post_info_obj = JSON.parse(post_info_str)
puts post_info_obj["form"].merge(client_info)
RestClient.post post_info_obj["url"], post_info_obj["form"].merge(client_info)

