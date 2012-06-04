require "rest-client"
require "json"

module Webhallon
  class Client
    #
    # @server String Full path to server
    #
    def initialize(server)
      @server = server
    end

    #
    # @return Boolean Is the server alive?
    #
    def connected?
      fetch("connected", "get")["connected"]
    end

    private

    #
    # @url String Relative path to be fetch
    # @method String Request type
    # @payload Hash Payload to server
    # @return Hash
    #
    def fetch(url, method, payload = {})
      JSON.parse(RestClient::Request.execute({
        method: method.to_sym, 
        url: url(url), 
        payload: payload, 
        headers: {}
      }))
    end

    #
    # @url String Relative path
    # @return Absolute path
    #
    def url(url)
      File.join(@server, url)
    end
  end
end