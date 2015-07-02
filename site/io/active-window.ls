_   = require \lodash
Os  = require \os
Ser = require \./servant
Xaw = require \./x11/active-window

const AWC = \active-window-changed
var http-ios, servants

module.exports = me =
  add-http-io: ->
    http-ios.push it
    me
  emit: ->
    notify-http-clients!
    notify-master!
  init: ->
    http-ios := []
    servants := {}
    Xaw.on \changed me.emit
    Ser.init!master?on \connect notify-master
    me
  servant:
    update: ->
      log 2 \servant.update it
      return unless it.event?id is AWC
      servants[h = it.hostname] = title:it.event.title
      notify-http-clients! if local-focus-is-on-servant h

function local-focus-is-on-servant
  _.contains Xaw.current.title.toUpperCase!, it.toUpperCase!

function notify-http-clients
  s = _.find servants, (v, k) -> local-focus-is-on-servant k
  t = Xaw.current.title
  t = "#t (#{s.title})" if s?
  log 2 \notify-http-clients AWC, t
  for io in http-ios then io.emit AWC, t

function notify-master
  Ser.master?emit \servant hostname:Os.hostname!, event:{id:AWC, title:Xaw.current.title}
