Evem = require \events .EventEmitter
X11  = require \x11
X11p = require \x11-prop
Root = require \./helper .root
X    = require \./helper .x

module.exports = me = new Evem!

X.ChangeWindowAttributes Root, eventMask:X11.eventMask.PropertyChange

X.InternAtom false, \_NET_ACTIVE_WINDOW, (err, atom) ->
  log "X.InternAtom _NET_ACTIVE_WINDOW failed", err if err

X.on \event, ->
  return unless it.atom is X.atoms._NET_ACTIVE_WINDOW
  err, wid <- X11p.get_property X, Root, X.atoms._NET_ACTIVE_WINDOW
  return log "get_property _NET_ACTIVE_WINDOW failed", err if err
  err, title <- X11p.get_property X, wid, X.atoms.WM_NAME
  return log "get_property WM_NAME failed: wid=#wid", err if err
  me.emit \changed, title.toString!
