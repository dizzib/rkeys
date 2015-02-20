Evem = require \events .EventEmitter
X11  = require \x11
Root = require \./helper .root
X    = require \./helper .x

module.exports = me = (new Evem!) with title:''

err, atom <- X.InternAtom false, \_NET_ACTIVE_WINDOW
return log "X.InternAtom _NET_ACTIVE_WINDOW failed", err if err

X.ChangeWindowAttributes Root, eventMask:X11.eventMask.PropertyChange
X.on \event, ->
  return unless it.atom is X.atoms._NET_ACTIVE_WINDOW
  <- read-active-window-title
  me.emit \changed

read-active-window-title!

function read-active-window-title cb
  err, prop <- X.GetProperty 0, Root, X.atoms._NET_ACTIVE_WINDOW, 0, 0, 10000000
  return log "X.GetProperty _NET_ACTIVE_WINDOW failed", err if err
  wid = prop.data.readUInt32LE 0
  err, prop <- X.GetProperty 0, wid, X.atoms.WM_NAME, X.atoms.STRING, 0, 10000000
  return log "X.GetProperty WM_NAME failed: wid=#wid", err if err
  me.title = prop.data.toString!
  cb! if cb