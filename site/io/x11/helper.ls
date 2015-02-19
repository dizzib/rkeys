X11 = require \x11
W4m = require \wait.for .forMethod

display = W4m X11, \createClient
root    = display.screen.0.root
x       = display.client .on \error, -> log \error, it

module.exports =
  display: display
  root   : root
  x      : x
