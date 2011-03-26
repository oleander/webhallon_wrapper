# Webhallon Wrapper

Used **_internally_** at [Radiofy.se](http://radiofy.se).

Makes it possible to interact against [libspotify](http://developer.spotify.com/en/libspotify/overview/) through the web.

## What can we do?

- Create playlists.
- Get info about a playlist.
- Delete a track at a given index.
- Add track to playlist.
- Check if the server is alive.

## How to use

### Initialize

The constructor takes one argument, the *Webhallon* server.  
It will raise an error if the URL is invalid.

    @ww = WebhallonWrapper.new("http://server:8181")
    
### Create a playlist

Create a non collaborative playlist.

    $ @ww.create("My Playlist")

Or pass the `collaborative` option.

    $ @ww.create("My Playlist", collaborative: false)

Create a public, collaborative playlist.

    $ @ww.create("My Playlist", collaborative: true)

### Get info about a playlist

    $ @ww.info("spotify:user:radiofy.se:playlist:47JbGTR8wxJw0SX0G1CJcS")

### Delete a track

Deletes the *last* track in the given playlist.

    $ @ww.delete("spotify:user:radiofy.se:playlist:47JbGTR8wxJw0SX0G1CJcS").index(-1)
    
Deletes the *fifth* track in the given playlist.
  
    $ @ww.delete("spotify:user:radiofy.se:playlist:47JbGTR8wxJw0SX0G1CJcS").index(4)
    
### Add track to playlist

Adds [track 1](spotify:track:2Huqz13a9lalQkSPeSk7Sy) and [track 2](spotify:track:2Huqz13a9lalQkSPeSk7Sy) to [list](spotify:user:radiofy.se:playlist:47JbGTR8wxJw0SX0G1CJcS) starting at index 1.

    $ @ww.add("spotify:track:2Huqz13a9lalQkSPeSk7Sy", "spotify:track:1mq756cRNyVTnykm4mHOgx").to("spotify:user:radiofy.se:playlist:47JbGTR8wxJw0SX0G1CJcS").starting_at(0)

### Is the server alive?

    $ @ww.alive?
    >> true
    
*The server blows up*
    
    $ @ww.alive?
    >> false

## Data to work with

Accessors for `#create` and `#info`.

- **name** (String) The name of the playlist.
- **link** (String) The spotify playlist url.
- **collaborative** (Boolean) Is the playlist collaborative?
- **length** (Integer) The amount of tracks in the playlist.
- **tracks** (Array<String>) A list of spotify tracks.

## Stuff to keep in mind

`Webhallon Wrapper` does not catch any errors, you have to do it by your self.

A request to the *Webhallon* server that takes longer that 10 seconds will cause a timeout error.
    
## How do install

Sorry, you can't.