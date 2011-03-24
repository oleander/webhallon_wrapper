require "rspec"
require "webmock/rspec"
require "webhallon_wrapper"
require "json/pure"

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.mock_with :rspec
end