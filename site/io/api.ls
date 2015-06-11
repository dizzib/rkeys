_    = require \lodash
Io   = require \socket.io
Cmd  = require \./command
Actw = require \./x11/active-window
Fc   = require \./filter-chain
Rks  = require \./rkeystrokes
Sc   = require \./side-chain

module.exports.init = (http) ->
  Actw.on \changed, -> io.emit \active-window-changed, Actw.title

  (io = Io http).on \connection, (socket) ->
    log 0, "connect #{ip = socket.conn.remoteAddress}"
    socket
      ..on \disconnect , -> log 0, "disconnect #ip"
      ..on \rkeydown   , -> apply-filters 0, it
      ..on \rkeyup     , -> apply-filters 1, it
      ..on \rkeystrokes, Rks
    Actw.emit \changed

    function apply-filters direction, act
      [id, command] = parse-act act
      Sc direction, id, command, io, act
      Fc direction, id, command, io

    function parse-act act
      [id, p-str] = if act is \: then [\:, ''] else act / \:
      cmd = Cmd.get-command id
      return [id, cmd] unless p-str?length
      p-arr = p-str / \,
      return [id, (replace-params cmd, p-arr)] unless _.isArray cmd
      [id, [(replace-params cmd.0, p-arr), (replace-params cmd.1, p-arr)]]

    function replace-params s, p-arr
      return s unless _.isString s
      for p, i in p-arr then s .= replace "$#i", p
      s
