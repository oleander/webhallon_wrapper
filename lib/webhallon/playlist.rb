module Webhallon
  class Playlist
    attr_reader :name, :link, :length, :tracks

    #
    # @args["name"] String Playlist name
    # @args["link"] String Spotify url
    # @args["length"] Integer Number of tracks
    # @args["tracks"] Array<String> A list of tracks
    # @args["collaborative"] Boolean Is the playlist collaborative?
    #
    def initialize(args)
      args.keys.each { |name| instance_variable_set "@" + name.to_s, args[name] }
    end

    #
    # @return Boolean Is the playlist collaborative?
    #
    def collaborative?
      @collaborative
    end
  end
end