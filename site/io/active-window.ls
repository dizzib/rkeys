_    = require \lodash
Os   = require \os
Args = require \../args
Wc   = require \./ws/client
Ws   = require \./ws/server
Xaw  = require \./x11/active-window

const AWC = \active-window-changed
servants = {}

module.exports = me =
  emit: ->
    notify-http-clients!
    notify-master!
  servant:
    update: ->
      log 2 \servant.update it
      return unless it.event?id is AWC
      servants[h = it.hostname] = title:it.event.title
      notify-http-clients! if local-focus-is-on-servant h

Xaw.on \changed me.emit
Wc.init(url).on \connect notify-master if url = Args.servant-to-url

function local-focus-is-on-servant
  _.contains Xaw.current.title.toUpperCase!, it.toUpperCase!

function notify-http-clients
  s = _.find servants, (v, k) -> local-focus-is-on-servant k
  t = Xaw.current.title
  t = "#t (#{s.title})" if s?
  log 2 \notify-http-clients AWC, t
  Ws.broadcast AWC, t

function notify-master
  return unless Args.servant-to-url
  Wc.send \servant hostname:Os.hostname!, event:{id:AWC, title:Xaw.current.title}
