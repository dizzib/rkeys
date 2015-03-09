X11 = require \x11
W4m = require \wait.for .forMethod

display = W4m X11, \createClient
root    = display.screen.0.root
x       = display.client .on \error, -> log \error, it
xtest   = W4m x, \require, \xtest # https://github.com/sidorares/node-x11/blob/master/examples/smoketest/xtesttest.js

module.exports =
  display: display
  root   : root
  x      : x
  xtest  : xtest
