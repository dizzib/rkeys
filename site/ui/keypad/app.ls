# set global log fn
# note we can't just set window.log = console.log because we'll get
# 'illegal invocation' errors, since console.log expects 'this' to be console.
window.log = -> console.log ...&

socket = io!
set-event-handler \touchstart, \addClass, \keydown
set-event-handler \touchend, \removeClass, \keyup

function set-event-handler touch-evname, class-fn-name, io-evname
  $ \.key .on touch-evname, ->
    ($key = $ this)[class-fn-name] \down
    socket.emit io-evname, $key.attr \id
    false
