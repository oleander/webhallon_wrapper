require "rest-client"
require "json/pure"
require "uri"

class WebhallonWrapper
  def initialize(site, option = {})
     raise StandardError.new("Invalid URL") if not site.to_s.match(URI.regexp)
     @config = {
       :site    => site.gsub(/(\/)$/, ""),
       :timeout => 10
     }.merge(option)
  end
  
  # Creates the playlist {name} 
  def create(name, args = {})
    options = {
      :name => name
    }
    options.merge!(:collaborative => args[:collaborative]) unless args[:collaborative].nil?
    data = get(:post, @config[:site], options)
    struct(data)
  end
  
  def info(playlist)
    data = get(:get, "#{@config[:site]}/#{playlist}")
    struct(data)
  end
  
  def delete(playlist)
    return tap { @playlist = playlist } unless @delete_index
    inner_delete(@delete_index, playlist)
  end
  
  def index(index)
    return tap { @delete_index = index } unless @playlist
    inner_delete(index, @playlist)
  end
  
  def everything
    inner_delete(nil, @playlist)
  end
  
  def rename(rename)
    tap { @rename = rename }
  end
  
  def add(*tracks)
    tap { @tracks = tracks }
  end
  
  def to(var)
    if @rename
      data = get(:post, @config[:site] + "/" + @rename, {:name => var})
      @rename = nil; data
    else
      tap { @playlist = var }
    end
  end
  
  def starting_at(index)
    raise ArgumentError.new("You have to call #to and #add first") if @tracks.nil? or @playlist.nil?
    get(:post, @config[:site] + "/" + @playlist, {:track => @tracks, :index => index})
  end
  
  def alive?
    !! get(:get, @config[:site])
  rescue RestClient::Exception
    false
  end
  
  private
    def struct(data)
      data = JSON.parse(data)
      Struct.new(*data.keys.map(&:to_sym)).new(*data.values)
    end
    
    def inner_delete(index, playlist)
      prefix = index ? "?index=#{index}" : nil
      get(:delete, "#{@config[:site]}/#{playlist}#{prefix}")
    end
    
    def get(*args)
      RestClient.send(args.first, *args[1..-1], :timeout => @config[:timeout])
    end
end