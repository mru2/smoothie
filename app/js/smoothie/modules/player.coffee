# A wrapper around the soundcloud player
# Responsible for playing tracks audio

define  ['when', 'smoothie/modules/soundcloud'], \

        (When, Soundcloud) ->


  # Player constructor
  class Player

    constructor: (opts) ->
      # Current player track id
      @track_id = opts.track_id

      # Associated SoundObject
      @stream = null

      # Associated pubsub
      @pubsub = opts.pubsub

      # Playing status
      @playing = false


    # Change the current track being played
    setTrackId: (track_id) ->
      return if track_id == @track_id

      @track_id = track_id

      # Cleans up the former stream behind it
      if @stream
        @stream.destruct() 
        @stream = null

      # Start it if player was playing
      this.play() if @playing


    # Pause the track
    pause: () ->
      @playing = false
      @stream.pause() if @stream


    # Play / Resume the track
    play: () ->
      @playing = true

      if @stream
        @stream.resume()

      else
        Soundcloud.getTrackStream(@track_id).then (stream) =>
          @stream = stream

          @stream.play {
            onfinish: this.onFinished
          }


    # Handles the finished track
    onFinished: () ->
      @pubsub.trigger 'player:finished'
