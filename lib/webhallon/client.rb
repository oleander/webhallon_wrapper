module Webhallon
  class Client < Webhallon::Base
    #
    # @return Boolean Is the server alive?
    #
    def connected?
      fetch("connected", "get")["connected"]
    end

    def playlists
      @_playlists ||= Webhallon::Playlists.new(server)
    end
  end
end