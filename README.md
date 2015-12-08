# MSS(Meituan Storage Service) SDK for Ruby

This is MSS SDK for Ruby.

## Introduction

### MSS服务介绍
美团云存储服务（Meituan Storage Service, 简称MSS)，是美团云对外提供的云存储服务，其具备高可靠，安全，低成本等特性，并且其API兼容S3。MSS适合存放非结构化的数据，比如图片，视频，文档，备份等。

### MSS基本概念介绍
MSS的API兼容S3, 其基本概念也和S3相同，主要包括Object, Bucket, Access Key, Secret Key等。

Object对应一个文件，包括数据和元数据两部分。元数据以key-value的形式构成，它包含一些默认的元数据信息，比如Content-Type, Etag等，用户也可以自定义元数据。

Bucket是object的容器，每个object都必须包含在一个bucket中。用户可以创建任意多个bucket。

Access Key和Secret Key: 用户注册MSS时，系统会给用户分配一对Access Key和Secret Key, 用于标识用户，用户在使用API使用MSS服务时，需要使用这两个Key。请在美团云管理控制台查询AccessKey和SecretKey。

### MSS访问域名
mtmss.com

## Installation

  安装MSS SDK for Ruby，需要ruby与gem，并且ruby版本在1.9.3以上。

	# Build MSS SDK for Ruby Gem
	gem build aws-sdk-v1.gemspec

	# Install MSS SDK for Ruby Gem
	gem install -l aws-sdk-v1-1.64.0.gem

## Quick Start

### 初始化

```ruby
	require 'aws-sdk-v1'
	s3 = AWS::S3.new({
		:s3_endpoint => 'mtmss.com',
		:use_ssl => false,
		:s3_force_path_style => true,
		:access_key_id => '****Access Key****',
		:secret_access_key => '****Access Secret****'})
```

### 新建bucket

```ruby
	bucket = s3.buckets.create('bucket_name')
```
	
### 列出所有bucket

```ruby
	s3.buckets.each do |bucket|
	  puts bucket.name
	end
```

### 设置bucket属性为公共可读

```ruby
	bucket.set_acl_public_read
```

### 设置bucket属性为私有

```ruby
	bucket.set_acl_private
```

### 判断bucket是否存在

```ruby
	bucket.exists?
```

### 从字符串或缓冲区上传对象

```ruby
	object_name_one = 'object1'
	object_content = 'test'
	obj = bucket.objects[object_name_one].write(object_content)
```

### 删除对象

```ruby
	obj.delete
```

### 从文件上传对象

```ruby
	object_name_for_test_upload = 'object2'
	upload_file_path = 'filepath'
	obj_upload = bucket.objects[object_name_for_test_upload]
	obj_upload.write(:file => upload_file_path)
```

### 下载对象到本地文件

```ruby
	File.open('output', 'wb') do |file|
    obj_upload.read do |chunk|
      file.write(chunk)
    end
  end
```

### 生成预签名的对象地址
  
```ruby
  temp_url_for_read = obj_upload.url_for(:read, {:expire => 600})
  puts temp_url_for_read
```

### 删除bucket内所有对象

```ruby
  bucket.clear!
```

### 删除bucket

```ruby
	bucket.delete
```

## 预签名Post上传对象

### 服务器端生成签名表单,用于发给客户端

```ruby
  post_info_str = s3.presigned_post_info(
    "share", # bucket名字
    {
    :expires => 300,                                        # 签名有效期，单位秒
    :metadata => {"x-amz-meta-server" => "Hello Server!"},  # 服务器端自定义的变量，必须以"x-amz-meta-"为前缀
    :callback_url => "http://mtmsscb.mtmss.cn",             # 上传成功后的回调url
    :callback_body => "name=${fname}&bucket=${bucket}&key=${key}&hash=${etag}&size=${fsize}&server=${x-amz-meta-server}&client=${x-amz-meta-client}",  # 上传成功后回调的内容，可以引用魔法变量和自定义变量
    :callback_body_type => "application/x-www-form-urlencoded",  # 上传成功后回调的Content-Type
    :callback_host => "mtmsscb.mtmss.com"                   # 上传成功后回调http header中的host，默认为callback_url中的host
    }).to_json
```

### 目前支持的魔法变量

  | 名字   | 描述                 |
  |--------|----------------------|
  | bucket | bucket名字           |
  | key    | 对象名字             |
  | etag   | 对象内容的md5sum     |
  | fname  | 上传表单中的filename |
  | fsize  | 对象大小             | 

### 客户端使用Post上传对象

```ruby
  # 这里使用ruby的rest-client做为示例
  client_info = {
    "x-amz-meta-client" => "Hello Client!",  # 客户端自定义变量，mss遵守标准S3协议，post表单最后一项必须是对象内容，因此客户端自定义的变量要写在value之前
    :key => "Key is lena.jpg",                      # 对象名字
    :value => File.new("./lena.jpg", 'rb'),  # 待上传的对象内容
  }
  post_info_obj = JSON.parse(post_info_str)  # post_info_str为服务器端生成的签名表单对象，包括url和form，其中form为表单内容，url为上传要用到的url
  RestClient.post post_info_obj["url"], post_info_obj["form"].merge(client_info)  # 与客户端自定义的表单内容合并后使用rest-client上传
```

### 回调服务器收到的消息体

```
  name=lena.jpg&bucket=share&key=Key is lena.jpg&hash="76d710edc4cf48d84e3cfc7e24234a09"&size=68261&server=Hello Server!&client=Hello Client!
```
