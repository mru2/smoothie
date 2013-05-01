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
        @stream = Soundcloud.getTrackStream @track_id, {
          onfinish:   () => @pubsub.trigger 'player:finished'
          onplay:     () => @pubsub.trigger 'player:playing'
          onresume:   () => @pubsub.trigger 'player:playing'
          onstop:     () => @pubsub.trigger 'player:paused'
          onpause:    () => @pubsub.trigger 'player:paused'
          onsuspend:  () => @pubsub.trigger 'player:paused'
        }

        @stream.play()
