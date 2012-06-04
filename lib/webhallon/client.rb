module Webhallon
  class Client < Webhallon::Base
    #
    # @return Boolean Is the server alive?
    #
    def connected?
      fetch("connected", "get")["connected"]
    end

    def playlists
      # Webhallon::Playlists.new()
    end
  end
end