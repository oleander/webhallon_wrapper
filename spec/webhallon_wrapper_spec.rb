describe Webhallon::Client do
  let(:socket) { Webhallon::Client.new("http://localhost:9292") }
  let(:playlist) { "spotify:user:radiofy.se:playlist:0wVa3u1ckpCraTnNw9dPCC" }
  let(:track) { "spotify:track:0FRelX0g1nNDFt6nvtiakE" }
  let(:tracks) { ["spotify:track:6tPbPginayIN9JdF3r7hB1", "spotify:track:3HVUvLe8yJ4WXLNMmfuisL"] }

  before(:each) do
    socket.tracks.wipe("spotify:user:radiofy.se:playlist:0wVa3u1ckpCraTnNw9dPCC")
  end
 
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
      p = socket.playlists.update({
        name: r_name,
        playlist: playlist
      })

      name2 = p.name
      name1.should_not eq(name2)

      validate(p)
    end
  end

  describe "tracks" do
    it "should be possible to add a track" do
      playlist1 = socket.playlists.information(playlist)
      playlist2 = socket.tracks.add({
        playlist: playlist,
        tracks: [track]
      })

      playlist1.length.should eq(playlist2.length - 1)
      validate(playlist2)
    end

    it "should be possible to wipe a playlist" do
      socket.tracks.wipe(playlist).should have(0).tracks
    end

    describe "ranges" do
      before(:each) do
        @list = [tracks.first]
        @list = @list + ([track] * 10)
        @list << tracks.last
        socket.tracks.wipe(playlist)

        socket.tracks.add({
          playlist: playlist,
          tracks: @list
        })
      end

      it "should keep a range, beginning" do
        p = socket.tracks.keep({
          playlist: playlist,
          range: 0..9
        })

        p.tracks.first.should eq(tracks.first)
        p.tracks.last.should eq(track)
        p.should have(10).tracks
      end

      it "should keep a range, end" do
        p = socket.tracks.keep({
          playlist: playlist,
          range: 5..1000
        })

        p.tracks.first.should eq(track)
        p.tracks.last.should eq(tracks.last)
        p.should have(@list.count - 5).tracks
      end

      it "doesn't matter if we're out of range" do
        p = socket.tracks.keep({
          playlist: playlist,
          range: 0..(@list.length + 1)
        })

        p.should have(@list.length).tracks
      end
    end
  end
end