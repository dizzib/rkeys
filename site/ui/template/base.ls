# set global log fn. We can't just set window.log = console.log because we'll get
# 'illegal invocation' errors, since console.log expects 'this' to be console.
window.log = -> console.log ...&

# set global web socket instance and helper
opts = maxReconnectInterval:5000ms
prot = location.protocol.replace \http \ws
window.ws = new ReconnectingWebSocket "#prot//#{location.host}" null opts
window.ws-send = (event-id, data) -> ws.send JSON.stringify "#event-id":data

ws.onmessage = ->
  msg = JSON.parse it.data
  return switch-layout l if l = msg.layout
  if title = msg.active-window-changed
    $ 'div[data-active-window-title]' .each ->
      rxstr = ($el = $ this).attr \data-active-window-title
      rx = new RegExp rxstr
      $el.toggle rx.test title

function switch-layout
  $ ".layout:not(.#it)" .hide!
  $ ".layout.#it" .show!
switch-layout \default
