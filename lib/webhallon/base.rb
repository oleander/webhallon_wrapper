require "rest-client"
require "json"
require "timeout"

module Webhallon
  class Base < Struct.new(:server)
    #
    # @server String Full path to server
    #
    # def initialize(server)
    #   @server = server
    # end

    protected

    #
    # @url String Relative path to be fetch
    # @method String Request type
    # @payload Hash Payload to server
    # @return Hash
    #
    def fetch(url, method, payload = {})
      Timeout::timeout(10) {
        JSON.parse(RestClient::Request.execute({
          method: method.to_sym,
          url: url(url),
          payload: payload,
          headers: {}
        }))
      }
    rescue Timeout::Error
      return {}
    rescue RestClient::Exception
      if $!.http_code.between?(400, 499)
        return {}
      else
        raise $!
      end
    end

    #
    # @url String Relative path
    # @return Absolute path
    #
    def url(url)
      File.join(server, url)
    end

    #
    # @response Hash
    # @return Webhallon::Playlist
    #
    def pack(response)
      Webhallon::Playlist.new(response)
    end
  end
end
