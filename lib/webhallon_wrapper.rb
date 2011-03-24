require "rest-client"
require "json/pure"
require "uri"

class WebhallonWrapper
  def initialize(site)
     raise StandardError.new if not site.to_s.match(URI.regexp) or site.to_s.match(/\/$/)
     @config = {
       site: site,
       timeout: 10
     }
  end
  
  def create(name)
    RestClient.post(@config[:site], {name: name}, timeout: @config[:timeout])
  end
  
  def info(playlist)
    data = RestClient.get("#{@config[:site]}/#{playlist}", timeout: @config[:timeout])
    struct(data)
  end
  
  def delete(playlist)
    tap { @playlist = playlist }
  end
  
  def index(value)
    RestClient.delete("#{@config[:site]}/#{@playlist}?index=#{value}", timeout: @config[:timeout])
  end
  
  private
    def struct(data)
      data = JSON.parse(data)
      Struct.new(*data.keys.map(&:to_sym)).new(*data.values)
    end
end
