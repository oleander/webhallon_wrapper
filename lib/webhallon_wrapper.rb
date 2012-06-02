require "rest-client"
require "json/pure"
require "uri"

class WebhallonWrapper
  def initialize(site, option = {})
     raise StandardError.new("Invalid URL") if not site.to_s.match(URI.regexp)
     @config = {
       :site    => site.gsub(/(\/)$/, ""),
       :timeout => 10,
       :retries => 10,
       :delay   => 10,
       :current => 0
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
    if @keep
      if index.is_a?(Range)
        @keep_index = index.to_a
      else
        @keep_index = [index]
      end

      return inner_keep(index, @keep)
    else
      unless @playlist
        return tap {
          if index.is_a?(Range)
            @delete_index = index.to_a
          else
            @delete_index = [index]
          end
        }
      end
      inner_delete(index, @playlist)
    end
  end
  
  def everything
    inner_delete(nil, @playlist)
  end
  
  def rename(rename)
    tap { @rename = rename }
  end

  def keep(playlist)
    tap { @keep =  playlist }
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
  
  # def alive?
  #   !! get(:get, @config[:site])
  # rescue RestClient::Exception
  #   false
  # end
  
  private
    def struct(data)
      data = JSON.parse(data)
      Struct.new(*data.keys.map(&:to_sym)).new(*data.values)
    end
  
    def inner_keep(index, playlist)
      params = []
      params << "#{@config[:site]}/#{playlist}/keep/tracks"
      params << { index: @keep_index }
      get(:post, *params)
    end    

    def inner_delete(index, playlist)
      params = []
      params << "#{@config[:site]}/#{playlist}/delete/tracks"
      params << { index: @delete_index }
      get(:post, *params)
    end
    
    def get(*args)
      begin
        RestClient.send(args[0], *args[1..-1])
      rescue RestClient::Exception, Errno::ECONNREFUSED => error
        if not error.to_s =~ /404/
          sleep(@config[:delay])
          if ((@config[:current] += 1) < @config[:retries])
            retry
          else
            raise error
          end
        else
          raise error
        end
      ensure
        @config[:current] = 0
      end
    end
end