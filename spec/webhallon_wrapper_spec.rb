def validate(playlist)
  playlist.name.should eq("This is a name")
  playlist.should have(0).tracks
  playlist.length.should be_zero
  playlist.should_not be_collaborative
  playlist.link.should match(/spotify:user:[\.\w]+:playlist:\w+/)
  playlist.should be_instance_of(Webhallon::Playlist)
end

describe Webhallon::Client do
  let(:socket) { Webhallon::Client.new("http://localhost:9292") }
  let(:playlist) { "spotify:user:radiofy.se:playlist:0wVa3u1ckpCraTnNw9dPCC" }

  use_vcr_cassette "client"

  describe "connected" do
    it "should be connected" do
      socket.should be_connected
    end
  end

  describe "create playlist" do
    it "should create a non collaborative playlist" do
      playlist = socket.playlists.create({
        name: "This is a name"
      })

      validate(playlist)
    end

    it "should create a collaborative playlist" do
      playlist = socket.playlists.create({
        name: "This is a name",
        collaborative: true
      })

      playlist.should be_collaborative

      playlist = socket.playlists.create({
        name: "This is a name",
        collaborative: false
      })

      playlist.should_not be_collaborative

      validate(playlist)
    end
  end

  describe "get information from playlist" do
    it "should return information about existing playlist" do
      validate(socket.playlists.information(playlist))
    end
  end

  describe "update playlist" do
    it "should be able to update playlist" do
      name1 = socket.playlists.information(playlist).name
      name2 = socket.playlists.update({
        name: r_name,
        playlist: playlist
      }).name

      name1.should_not eq(name2)
    end
  end
end