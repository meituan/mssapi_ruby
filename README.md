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

    安装MSS SDK for Ruby，需要ruby版本在1.9.3以上。

    # Build ruby
    首先下载ruby1.9.3源码文件
    其次解压缩文件，进入该文件目录，编译安装ruby
    ./configure
    make
    sudo make install
    默认情况下ruby安装在/usr/local/bin/下，安装完成后，如果运行ruby -v 提示未找到ruby命令，可以通过在PATH环境变量中添加‘/usr/local/bin’目录，或者使用‘/usr/local/bin/ruby -v’命令。


	# Build gem
	git clone https://github.com/rubygems/rubygems.git
	ruby setup.rb

	# Build MSS SDK for Ruby Gem
	gem build aws-sdk-v1.gemspec

	# Install MSS SDK for Ruby Gem
	gem install -l aws-sdk-v1-1.64.0.gem

## Quick Start

	require 'aws-sdk-v1'

	s3 = AWS::S3.new({
		:s3_endpoint => 'mtmss.com',
		:use_ssl => false,
		:s3_force_path_style => true,
		:access_key_id => '****Access Key****',
		:secret_access_key => '****Access Secret****'})

	# Create bucket
	bucket = s3.buckets.create('bucket_name')
	
	# List bucket
	s3.buckets.each do |bucket|
	  puts bucket.name
	end

	# Make bucket public
	bucket.set_acl_public_read

	# Make bucket private
	bucket.set_acl_private

	# Does bucket exist?
	bucket.exists?

	# Create object
	object_name_one = 'object1'
	object_content = 'test'
	obj = bucket.objects[object_name_one].write(object_content)

	# Delete object
	obj.delete

	# upload file
	object_name_for_test_upload = 'object2'
	upload_file_path = 'filepath'
	obj_upload = bucket.objects[object_name_for_test_upload]
	obj_upload.write(:file => upload_file_path)

	# download object to local file
	File.open('output', 'wb') do |file|
        obj_upload.read do |chunk|
            file.write(chunk)
        end
    end

    # generate presign(temp) url for another user to read or download
    temp_url_for_read = obj_upload.url_for(:read, {:expire => 600})
    puts temp_url_for_read

    # delete all the object in the bucket
    bucket.clear!

	# Delete bucket
	bucket.delete
