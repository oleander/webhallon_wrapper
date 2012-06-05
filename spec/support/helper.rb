require "digest/md5"

module Helper
  def r_name
    Digest::MD5.hexdigest(Time.now.to_f.to_s)
  end

  def validate(playlist)
    playlist.name.should_not be_empty
    playlist.tracks.count.should >= 0
    playlist.length.should eq(playlist.tracks.count)
    [true, false].should include(playlist.collaborative?)
    playlist.link.should match(/spotify:user:[\.\w]+:playlist:\w+/)
    playlist.should be_instance_of(Webhallon::Playlist)
  end
end
  
