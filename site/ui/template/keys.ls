socket = io!
set-event-handler \touchstart, \down
set-event-handler \touchend  , \up

function set-event-handler touch-evname, direction
  $ \.key .on touch-evname, ->
    return if ($key = $ this).hasClass direction # ignore duplicates
    $key.toggleClass 'down up'
    socket.emit "key#direction", $key.attr \id
    false
