# Webhallon Wrapper

Used **_internally_** at [Radiofy.se](http://radiofy.se).

Makes it possible to interact against [libspotify](http://developer.spotify.com/en/libspotify/overview/) through the web.

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
    
    $ result = @ww.create("My Playlist")
    
    $ result.name
    >> "My Playlist"
    
    $ result.link
    >> "spotify:user:radiofy.se:playlist:47JbGTR8wxJw0SX0G1CJcS"
    
    $ result.collaborative
    >> false
    
    $ result.length
    >> 0
    
    $ result.tracks
    >> []

### Get info about a playlist

`#info` will have the same attributes as the object returned by `#create`.

    $ result = @ww.info("spotify:user:radiofy.se:playlist:47JbGTR8wxJw0SX0G1CJcS")

### Delete a track

Deletes the *last* track in the given playlist.

    $ @ww.delete("spotify:user:radiofy.se:playlist:47JbGTR8wxJw0SX0G1CJcS").index(-1)
    
Deletes the *fifth* track in the given playlist.
  
    $ @ww.delete("spotify:user:radiofy.se:playlist:47JbGTR8wxJw0SX0G1CJcS").index(5) 
    
### Add track to playlist

Adds [track 1](spotify:track:2Huqz13a9lalQkSPeSk7Sy) and [track 2](spotify:track:2Huqz13a9lalQkSPeSk7Sy) to [list](spotify:user:radiofy.se:playlist:47JbGTR8wxJw0SX0G1CJcS) starting at index 1.

    $ @ww.add("spotify:track:2Huqz13a9lalQkSPeSk7Sy", "spotify:track:1mq756cRNyVTnykm4mHOgx").to("spotify:user:radiofy.se:playlist:47JbGTR8wxJw0SX0G1CJcS").starting_at(1)

### Is the server alive?

    $ @ww.alive?
    >> true
    
*The server blows up*
    
    $ @ww.alive?
    >> false

## Stuff to keep in mind

`Webhallon Wrapper` does not catch any errors, you have to do it by your self.

A request to the *Webhallon* server that takes longer that 10 seconds will cause a timeout error.
    
## How do install

Sorry, you can't.