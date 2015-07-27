# MSS(Meituan Storage Service) for Ruby - Version 1

This is version 1 of the MSS SDK for Ruby.

## Installation

Version 1 of the MSS SDK for Ruby is available on rubygems.org as two gems:

* `aws-sdk-v1`
* `aws-sdk`

This project uses [semantic versioning](http://semver.org/). If you are using the
`aws-sdk` gem, we strongly recommend you specify a version constraint in
your Gemfile. Version 2 of the Ruby SDK will not be backwards compatible
with version 1.

    # version constraint
    gem 'aws-sdk', '< 2'

    # or use the v1 gem
    gem 'aws-sdk-v1'

If you use the `aws-sdk-v1` gem, you may also load the v2 Ruby SDK in the
same process; The v2 Ruby SDK uses a different namespace, making this possible.

    # when the v2 SDK ships, you will be able to do the following
    gem 'aws-sdk', '~> 2.0'
    gem 'aws-sdk-v1'

If you are currently using v1 of `aws-sdk` and you update to `aws-sdk-v1`, you
may need to change how you require the Ruby SDK:

    require 'aws-sdk-v1' # not 'aws-sdk'

If you are using a version of Ruby older than 1.9, you may encounter problems with Nokogiri.
The authors dropped support for Ruby 1.8.x in Nokogiri 1.6. To use aws-sdk, you'll also have
to install or specify a version of Nokogiri prior to 1.6, like this:

    gem 'nokogiri', '~> 1.5.0'

## Basic Configuration

You need to provide your MSS security credentials and choose a default region.

```
AWS.config(access_key_id: '...', secret_access_key: '...', region: 'us-west-2')
```

You can also specify these values via `ENV`:

    export AWS_ACCESS_KEY_ID='...'
    export AWS_SECRET_ACCESS_KEY='...'
    export AWS_REGION='us-west-2'

