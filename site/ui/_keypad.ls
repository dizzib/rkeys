socket = io!
set-event-handler \touchstart, \addClass   , \keydown
set-event-handler \touchend  , \removeClass, \keyup

function set-event-handler touch-evname, class-fn-name, io-evname
  $ \.key .on touch-evname, ->
    ($key = $ this)[class-fn-name] \down
    socket.emit io-evname, $key.attr \id
    false
