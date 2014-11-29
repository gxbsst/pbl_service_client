require 'bundler/setup'
Bundler.setup

require 'pbl_service_client'
require 'webmock/rspec'

I18n.config.enforce_available_locales = false

RSpec.configure do |config|

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:each) do
    stub_request(:post, "0.0.0.0:3001/users").with(
      body: hash_including(default_params),
      headers:  { 'Accept' => 'application/vnd.ibridgebrige.com; version=1'}
    ).to_return(:status => 200, :body => "", :headers => {})
  end
end
