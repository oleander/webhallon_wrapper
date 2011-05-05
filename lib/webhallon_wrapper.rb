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
  def create(name, args = {:collaborative => false})
    data = RestClient.post(@config[:site], {:name => name, :collaborative => args[:collaborative]}, :timeout => @config[:timeout])
    struct(data)
  end
  
  def info(playlist)
    data = RestClient.get("#{@config[:site]}/#{playlist}", :timeout => @config[:timeout])
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
      data = RestClient.post(@config[:site] + "/" + @rename, {:name => var}, :timeout => @config[:timeout])
      @rename = nil; data
    else
      tap { @playlist = var }
    end
  end
  
  def starting_at(index)
    raise ArgumentError.new("You have to call #to and #add first") if @tracks.nil? or @playlist.nil?
    RestClient.post(@config[:site] + "/" + @playlist, {:track => @tracks, :index => index}, :timeout => @config[:timeout])
  end
  
  def alive?
    !! RestClient.get(@config[:site], :timeout => @config[:timeout])
  rescue StandardError
    false
  end
  
  private
    def struct(data)
      data = JSON.parse(data)
      Struct.new(*data.keys.map(&:to_sym)).new(*data.values)
    end
    
    def inner_delete(index, playlist)
      prefix = index ? "?index=#{index}" : nil
      RestClient.delete("#{@config[:site]}/#{playlist}#{prefix}", :timeout => @config[:timeout])
    end
end
