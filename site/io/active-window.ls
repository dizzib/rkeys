_   = require \lodash
Xaw = require \./x11/active-window

ios = []

module.exports = me =
  add-io: (io) ->
    ios.push io
    me
  emit: ->
    for io in ios then io.emit \active-window-changed Xaw.title
  init: ->
    ios.clear
    Xaw.on \changed me.emit
    me
