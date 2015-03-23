# set global log fn. We can't just set window.log = console.log because we'll get
# 'illegal invocation' errors, since console.log expects 'this' to be console.
window.log = -> console.log ...&

socket = io!

# active window
socket.on \active-window-changed, (title) ->
  $ 'div[data-active-window-title]' .each ->
    rxstr = ($el = $ this).attr \data-active-window-title
    rx = new RegExp rxstr
    $el.toggle rx.test title

# layouts
function show-layout n
  const MAX-LAYOUT = 3
  for i from 0 to MAX-LAYOUT then $ ".layout-#i" .toggle i is parseInt n, 10
socket.on \layout, show-layout
show-layout 0
