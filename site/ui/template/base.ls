socket = io!

socket.on \active-window-changed, (title) ->
  $ 'div[data-active-window-title]' .each ->
    rxstr = ($el = $ this).attr \data-active-window-title
    rx = new RegExp rxstr
    $el.toggle rx.test title
