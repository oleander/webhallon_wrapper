# Webhallon Client

Used **_internally_** at [Radiofy.se](http://radiofy.se).

## How to use

### Initialize

```` ruby
socket = Webhallon::Client.new("http://server:8181")
````

### Playlist

#### Create

Create a non collaborative playlist.

```` ruby
socket.create({
  name: "My playlist",
  collaborative: false
})
````

#### Information

```` ruby
socket.information("spotify:user:username:playlist:47JbGTR8wxJw0SX0G1CJcS")
````

#### Update

```` ruby
socket.update({
  playlist: "spotify:user:username:playlist:47JbGTR8wxJw0SX0G1CJcS",
  name: "New name",
  collaborative: false
})
````

### Tracks


#### Add

``` ruby
socket.tracks.add({
  playlist: "spotify:user:username:playlist:47JbGTR8wxJw0SX0G1CJcS",
  tracks: ["spotify:track:2Huqz13a9lalQkSPeSk7Sy"],
  index: 0
})
```

#### Range

``` ruby
socket.tracks.keep({
  playlist: "spotify:user:username:playlist:47JbGTR8wxJw0SX0G1CJcS",
  range: 30..50
})
```

### Webhallon::Playlist

- **name** (String) The name of the playlist.
- **link** (String) The spotify playlist url.
- **length** (Integer) The amount of tracks in the playlist.
- **tracks** (Array< String >) A list of spotify tracks.
- **collaborative?** (Boolean) Is the playlist collaborative?

## Requirements

*Webhallon* is tested in *OS X 10.7.4* using Ruby *1.9.2*.

## License

*Webhallon* is released under the *MIT license*.