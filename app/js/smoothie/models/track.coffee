# Track model
# Wraps a SoundCloud Track to make it a usable model
# Not a backbone model (not the use right now, since it is read only)

define ['soundcloud'] \

        (Soundcloud) ->

  Track = ( () -> 

    {

      # Initialize from a soundcloud ID
      initialize: (id) ->


      # Get its attributes for rendering
      attributes: () ->
  
    }

  )()
