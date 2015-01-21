Io = require \socket.io
X  = require \./x

module.exports.init = (http) ->
  io = Io http

  socket <- io.on \connection
  log \connect

  socket.on \disconnect, ->
    log \disconnect

  socket.on \keydown, ->
    #log \keydown, it
    X.keydown it

  socket.on \keyup, ->
    #log \keyup, it
    X.keyup it
