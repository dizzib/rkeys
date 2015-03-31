socket = io!

$ '.latching .key, .key.latching' .on \touchend ->
  x = it.originalEvent.changedTouches.0.pageX - window.pageXOffset
  y = it.originalEvent.changedTouches.0.pageY - window.pageYOffset
  return unless target = document.elementFromPoint x, y
  return if ($t = $ target).is ($key = $ this)
  return if $t.parents!is $key
  it.stopImmediatePropagation!

set-event-handler \touchstart, \down
set-event-handler \touchend  , \up

function set-event-handler touch-evname, direction
  $ \.key .on touch-evname, ->
    return if ($key = $ this).hasClass direction # ignore duplicates
    $key.toggleClass 'down up'
    socket.emit "key#direction", $key.attr \id
    false
