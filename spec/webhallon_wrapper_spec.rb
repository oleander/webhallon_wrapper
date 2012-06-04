describe Webhallon::Client do
  let(:socket) { Webhallon::Client.new("http://localhost:9292") }
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

      playlist.name.should eq("This is a name")
      playlist.should have(0).tracks
      playlist.length.should be_zero
      playlist.should_not be_collaborative
      playlist.link.should match(/spotify:user:[\.\w]+:playlist:\w+/)
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
    end
  end
end