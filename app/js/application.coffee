# For testing
window.Player = {

  next: () ->
    $('.track.previous').remove()
    $('.track.current').removeClass('current').addClass('previous')
    $('.track.next').removeClass('next').addClass('current')

  previous: () ->
    $('.track.next').remove()
    $('.track.current').removeClass('current').addClass('next')
    $('.track.previous').removeClass('previous').addClass('current')

}