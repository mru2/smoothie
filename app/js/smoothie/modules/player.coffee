# A wrapper around the soundcloud player
# Responsible for playing tracks audio

define  ['when', 'smoothie/modules/soundcloud'], \

        (When, Soundcloud) ->


  # Player constructor
  Player = (opts) ->
    # Current player track id
    @track_id = opts.track_id

    # Associated SoundObject
    @stream = null

    # Associated pubsub
    @pubsub = opts.pubsub


  # Change the current track being played
  Player.prototype.setTrackId = (track_id) ->
    @track_id = track_id
    @stream.destruct() if @stream


  # Pause the track
  Player.prototype.pause = () ->
    @stream.pause() if @stream


  # Play / Resume the track
  Player.prototype.play = () ->
    unless @stream
      Soundcloud.getTrackStream(@track_id).then (stream) =>
        @stream = stream

    @stream.play {
      onfinish: onFinished
    }


  # Handles the finished track
  Player.prototype.onFinished = () ->
    @pubsub.trigger 'player:finished'


  Player