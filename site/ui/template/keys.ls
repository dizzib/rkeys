$ '.latchable .key, .key.latchable'
  ..on \touchstart ->
    $key.trigger \latch if ($key = $ this).hasClass \up
  ..on \touchend ->
    x = it.originalEvent.changedTouches.0.pageX - window.pageXOffset
    y = it.originalEvent.changedTouches.0.pageY - window.pageYOffset
    return unless target = document.elementFromPoint x, y
    $t = ($ target).add ($ target).parents!
    return $key.trigger \unlatch if $t.is ($key = $ this)
    it.stopImmediatePropagation!

set-event-handler \touchstart \down
set-event-handler \touchend   \up

function set-event-handler touch-evname, direction
  $ \.key .on touch-evname, ->
    return if ($key = $ this).hasClass direction # ignore duplicates
    $key.toggleClass 'down up'
    ws.send JSON.stringify "rkey#direction": $key.attr \id
    false
