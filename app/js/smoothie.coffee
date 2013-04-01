window.Smoothie = {
  Models: {},
  Views: {},
  Modules: {},
}


# Initializing
$ () ->
  Smoothie.Views.PlayerView.bootstrap()


# Smoothie.start()


# # For testing
# window.Player = {
#   next: () ->
#     $('.track.previous').remove()
#     $('.track.current').removeClass('current').addClass('previous')
#     $('.track.next').removeClass('next').addClass('current')

#   previous: () ->
#     $('.track.next').remove()
#     $('.track.current').removeClass('current').addClass('next')
#     $('.track.previous').removeClass('previous').addClass('current')
# }



# class Playlist
#   -> nextTrack
#   -> previousTrack
#   (-> shuffle)
#   (-> liked)
 
#   currentTrackChanged ->
#   previousTrackChanged ->
#   nextTrackChanged ->

#   getCurrentTrack
#   getNextTrack
#   getPreviousTrack    

# class PlayerView

#   class ControlsView
#     play ->
#     pause ->
#     nextTrack ->
#     previousTrack ->
#     (shuffle ->)
#     (like ->)

#     -> playing
#     -> paused

#   class TrackView
#     -> trackChanged

# class MusicPlayer
#   -> play 
#   -> pause
#   -> currentTrackChanged

#   playing ->
#   paused ->

# class Track
