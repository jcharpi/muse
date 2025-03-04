struct User: SpotifyAccount, MusicDisplayable {
  let id: String
  let displayName: String
  let images: [SpotifyImage]
  // user playback state (nil = inactive)
  var listeningTo: SpotifyTrack?
    
  // Controlled construction for partial state simulation
  public init(
    id: String,
    displayName: String,
    images: [SpotifyImage],
    listeningTo: SpotifyTrack? = nil
  ) {
    self.id = id
    self.displayName = displayName
    self.images = images
    self.listeningTo = listeningTo
  }
}
