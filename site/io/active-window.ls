_   = require \lodash
Xaw = require \./x11/active-window

ios = []

module.exports =
  init: (io) ->
    ios.push io
    Xaw.on \changed -> for io in ios then io.emit \active-window-changed Xaw.title
    Xaw.emit \changed
