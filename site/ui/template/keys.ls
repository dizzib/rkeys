socket = io!
set-event-handler \touchstart, \keydown
set-event-handler \touchend  , \keyup

function set-event-handler touch-evname, io-evname
  $ \.key .on touch-evname, ->
    ($key = $ this).toggleClass 'down up'
    socket.emit io-evname, $key.attr \id
    false
