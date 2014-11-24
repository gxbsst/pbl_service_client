# PblServiceClient

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pbl_service_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pbl_service_client

## Usage

### User

#### 创建某一用户

``` ruby
params = {
first_name: 'first_name', 
last_name: 'last_name', 
age: 20, 
gender: 1, 
email: email,
password: password
}
PBL::Client::Users::User.create(

)
```






## Contributing

1. Fork it ( https://github.com/[my-github-username]/pbl_service_client/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
