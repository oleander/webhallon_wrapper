module Webhallon
  class Tracks < Webhallon::Base
    #
    # @args[:playlist] String Spotify Playlist
    # @args[:tracks] Array<String> A list of tracks
    # @args[:index] Integer Index position for tracks
    # @return Webhallon::Playlist
    #
    def add(args)
      response = fetch("/#{args.fetch(:playlist)}/tracks", :post, {
        tracks: args.fetch(:tracks), 
        index: args[:index] || 0
      })

      Webhallon::Playlist.new(response)
    end

    def wipe(playlist)
      response = fetch("/#{playlist}/tracks", :delete)
      Webhallon::Playlist.new(response)
    end
  end
end