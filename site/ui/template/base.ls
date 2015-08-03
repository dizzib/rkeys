# set global log fn. We can't just set window.log = console.log because we'll get
# 'illegal invocation' errors, since console.log expects 'this' to be console.
window.log = -> console.log ...&

# set global web socket instance
window.ws = new WebSocket "ws://#{location.host}"
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
