X11 = require \x11

module.exports = me =
  init: (cb) ->
    err, me.display <- X11.createClient
    return cb err if err
    me.root = me.display.screen.0.root
    me.x = me.display.client .on \error -> log \error it
    err, me.xtest <- me.x.require \xtest # https://github.com/sidorares/node-x11/blob/master/examples/smoketest/xtesttest.js
    cb err
