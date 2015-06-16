X11 = require \x11
W4m = require \wait.for .forMethod

module.exports = me =
  init: ->
    me.display = W4m X11, \createClient
    me.root    = me.display.screen.0.root
    me.x       = me.display.client .on \error, -> log \error, it
    me.xtest   = W4m me.x, \require, \xtest # https://github.com/sidorares/node-x11/blob/master/examples/smoketest/xtesttest.js

for sig in <[ SIGINT SIGHUP SIGTERM ]> then process.on sig, process.exit
