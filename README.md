# Webhallon Wrapper

Used **_internally_** at [Radiofy.se](http://radiofy,se).

Makes it possible to interact against [libspotify](http://developer.spotify.com/en/libspotify/overview/), through the web.

## What can we do?

- Create playlists.
- Get info about a playlist.
- Delete a track at a given index.
- Add tracks to playlist.
- Rename playlist.
- Check if the server is alive.

## How to use

### Initialize

The constructor takes two argument, the *Webhallon* server and an option param.  
It will raise an error if the URL is invalid.
The `options` param is optimal.

```` ruby
@ww = WebhallonWrapper.new("http://server:8181", options)
````
#### Option param

```` ruby
options = {
  timeout: 10,
  retries: 10,
  delay: 10
}
````

- **timeout** (*Fixnum*) Maximum time for each request. *Default* is 10.
- **retries** (*Fixnum*) Maximum retries if an timeout occur. *Default* is 10.
- **delay** (*Fixnum*) Time to sleep between each retry. *Default* is 10.

### Create a playlist

Create a non collaborative playlist.

```` ruby
@ww.create("My Playlist")
````

Or pass the `collaborative` option.

```` ruby
@ww.create("My Playlist", collaborative: false)
````

Create a public, collaborative playlist.

```` ruby
@ww.create("My Playlist", collaborative: true)
````

### Get info about a playlist

```` ruby
@ww.info("spotify:user:username:playlist:47JbGTR8wxJw0SX0G1CJcS")
````

### Rename playlist

```` ruby
@ww.rename("spotify:user:username:playlist:47JbGTR8wxJw0SX0G1CJcS").to("Any name")
````

### Delete a track

Deletes the *last* track in the given playlist.

```` ruby
@ww.delete("spotify:user:username:playlist:47JbGTR8wxJw0SX0G1CJcS").index(-1)
````

Deletes the *fifth* track in the given playlist.

```` ruby  
@ww.delete("spotify:user:username:playlist:47JbGTR8wxJw0SX0G1CJcS").index(4)
````

Deletes everything in the given list.

```` ruby
@ww.delete("spotify:user:username:playlist:47JbGTR8wxJw0SX0G1CJcS").everything
````

Deletes a range

```` ruby
@ww.delete("spotify:user:username:playlist:47JbGTR8wxJw0SX0G1CJcS").index(30..40)
````

#### Keep

```` ruby
@ww.keep("spotify:user:username:playlist:47JbGTR8wxJw0SX0G1CJcS").index(0..399)
````

### Add track to playlist

Adds [track 1](spotify:track:2Huqz13a9lalQkSPeSk7Sy) and [track 2](spotify:track:2Huqz13a9lalQkSPeSk7Sy) to [list](spotify:user:username:playlist:47JbGTR8wxJw0SX0G1CJcS) starting at index 1.

```` ruby
@ww.add("spotify:track:2Huqz13a9lalQkSPeSk7Sy", "spotify:track:1mq756cRNyVTnykm4mHOgx").to("spotify:user:username:playlist:47JbGTR8wxJw0SX0G1CJcS").starting_at(0)
````

### Is the server alive?

```` ruby
@ww.alive?
# => true
````

*The server blows up*

```` ruby    
@ww.alive?
# => false
````

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

## Requirements

*Webhallon Wrapper* is tested in *OS X 10.6.7* using Ruby *1.8.7*, *1.9.2*.

## License

*Webhallon Wrapper* is released under the *MIT license*.