module Webhallon
  class Tracks < Webhallon::Base
    #
    # @args[:playlist] String Spotify Playlist
    # @args[:tracks] Array<String> A list of tracks
    # @args[:index] Integer Index position for tracks
    # @return Webhallon::Playlist
    #
    def add(args)
      pack(fetch("/#{args.fetch(:playlist)}/tracks", :post, {
        tracks: args.fetch(:tracks), 
        index: args[:index] || 0
      }))
    end

    #
    # @playlist String Spotify Playlist
    # @return Webhallon::Playlist
    #
    def wipe(playlist)
      pack(fetch("/#{playlist}/tracks", :delete))
    end

    #
    # @args[:playlist] String Spotify Playlist
    # @args[:range] Range
    #
    def keep(args)
      pack(fetch("/#{args.fetch(:playlist)}/tracks/keep", :post, {
        from: args.fetch(:range).first,
        to: args.fetch(:range).last
      }))
    end
  end
end