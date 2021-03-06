require "webhallon_wrapper"
require "rspec"
require "vcr"
require_relative "./support/helper"

RSpec.configure do |config|
  config.mock_with :rspec
  config.extend VCR::RSpec::Macros
  config.include Helper
end

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  c.hook_into :webmock
  c.default_cassette_options = {
    record: :all
  }
  c.allow_http_connections_when_no_cassette = true
end