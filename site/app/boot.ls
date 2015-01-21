# set global log fn
# note we can't just set window.log = console.log because we'll get
# 'illegal invocation' errors, since console.log expects 'this' to be console.
window.log = -> console.log ...&

socket = io!

$ '.key' .on \touchstart, ->
  ($key = $ this).addClass \down
  socket.emit \keydown, $key.attr \id
  false

$ '.key' .on \touchend, ->
  ($key = $ this).removeClass \down
  socket.emit \keyup, $key.attr \id
  false
