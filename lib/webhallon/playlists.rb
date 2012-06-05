module Webhallon
  class Playlists < Webhallon::Base
    #
    # @args[:name] Name of playlist. Required.
    # @args[:collaborative] Boolean Should playlist be collaborative?
    # @return Webhallon::Playlist
    #
    def create(args)
      response = fetch("/", :post, {
        name: args.fetch(:name), 
        collaborative: args[:collaborative] ? "1" : "0"
      })

      Webhallon::Playlist.new(response)
    end

    #
    # @playlist String Playlist to be fetched
    # @return Webhallon::Playlist
    #
    def information(playlist)
      Webhallon::Playlist.new(fetch("/#{playlist}", :get))
    end

    #
    # @args[:playlist] String Spotify playlist
    # @args[:name] Name of playlist. Required.
    # @return Webhallon::Playlist
    #
    def update(args)
      response = fetch("/#{args.fetch(:playlist)}", :put, {
        name: args.fetch(:name)
      })

      Webhallon::Playlist.new(response)
    end
  end
end