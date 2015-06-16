Evem = require \events .EventEmitter
X11  = require \x11
Root = require \./helper .root
X    = require \./helper .x

module.exports = me = (new Evem!) with do
  init: ->
    err, atom <- X.InternAtom false, \_NET_ACTIVE_WINDOW
    return log "X.InternAtom _NET_ACTIVE_WINDOW failed", err if err
    X.ChangeWindowAttributes Root, eventMask:X11.eventMask.PropertyChange
    X.on \event, ->
      return unless it.atom is X.atoms._NET_ACTIVE_WINDOW
      <- read-active-window-title
      me.emit \changed
    read-active-window-title!
  title:''

function read-active-window-title cb
  err, p <- X.GetProperty 0, Root, X.atoms._NET_ACTIVE_WINDOW, 0, 0, 10000000
  return log "X.GetProperty _NET_ACTIVE_WINDOW failed", err if err
  return unless wid = p.data.readUInt32LE 0 # switching desktop returns 0
  err, p <- X.GetProperty 0, wid, X.atoms.WM_NAME, 0, 0, 10000000
  return log "X.GetProperty WM_NAME failed: wid=#wid", err if err
  me.title = p.data.toString!
  log 2, "read-active-window-title=#{me.title}"
  cb! if cb
