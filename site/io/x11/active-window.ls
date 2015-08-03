Evem = require \events .EventEmitter
Util = require \util
X11  = require \x11
Root = require \./helper .root
X    = require \./helper .x

module.exports = me = (new Evem!) with do
  init: (cb) ->
    me.removeAllListeners!
    xerr <- X.InternAtom false \_NET_ACTIVE_WINDOW
    return cb wrap-xerr "x.InternAtom _NET_ACTIVE_WINDOW failed" xerr if xerr
    X.ChangeWindowAttributes Root, eventMask:X11.eventMask.PropertyChange
    X.on \event ->
      return unless it.atom is X.atoms._NET_ACTIVE_WINDOW
      err, s <- get-active-window-state
      return log err if err
      return unless s?
      return if s.wid is me.current.wid # dedupe duplicate events race
      me.current = s
      log2 "active-window=#{Util.inspect s}"
      me.emit \changed
    get-active-window-state cb
  current:
    title: ''
    wid  : 0

function get-active-window-state cb
  xerr, p <- X.GetProperty 0, Root, X.atoms._NET_ACTIVE_WINDOW, 0, 0, 10000000
  return cb wrap-xerr "X.GetProperty _NET_ACTIVE_WINDOW failed" xerr if xerr
  return cb! unless wid = p.data.readUInt32LE 0 # switching desktop returns 0
  xerr, p <- X.GetProperty 0, wid, X.atoms.WM_NAME, 0, 0, 10000000
  return cb wrap-xerr "X.GetProperty WM_NAME failed (wid=#wid)" xerr if xerr
  cb null title:p.data.toString!, wid:wid

function wrap-xerr msg, xerr
  (new Error "#msg. #{xerr.message}") with xerr:xerr
