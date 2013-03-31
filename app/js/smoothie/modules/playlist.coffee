Playlist = (Track) -> 
  
  # Mockup data
  tracks = [
    {
      artwork: 'https://i4.sndcdn.com/artworks-000034170195-wb7buo-t500x500.jpg',
      
    },
    {

    },
    {

    }
  ]


  index = 1

  # The public interface delivered
  _.extend Backbone.Events, {
    getPreviousTrack: () ->
      tracks[index - 1]

    getCurrentTrack: () ->
      tracks[index]

    getNextTrack: () ->
      tracks[index + 1]
  }


Smoothie.Modules.Playlist = Playlist(
  Smoothie.Models.Track
)