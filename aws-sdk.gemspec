version = File.read(File.expand_path('../VERSION', __FILE__)).strip

Gem::Specification.new do |s|
  s.name = 'aws-sdk'
  s.version = version
  s.summary = 'AWS SDK for Ruby V1'
  s.description = <<-DESCRIPTION.strip
Version 1 of the AWS SDK for Ruby. Available as both `aws-sdk` and `aws-sdk-v1`.
Use `aws-sdk-v1` if you want to load v1 and v2 of the Ruby SDK in the same
application.
  DESCRIPTION
  s.license = 'Apache 2.0'
  s.author = 'Amazon Web Services'
  s.homepage = 'http://aws.amazon.com/sdkforruby'
  s.add_dependency('aws-sdk-v1', version)
  s.files = ['lib/aws-sdk.rb']
end
