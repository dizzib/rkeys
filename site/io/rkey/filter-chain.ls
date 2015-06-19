Bro = require \./filter/broadcast
But = require \./filter/button
Jsc = require \./filter/javascript
Lsc = require \./filter/livescript
Kfo = require \./filter/key-follow
Ksq = require \./filter/key-sequence
Nop = require \./filter/nop
She = require \./filter/shell-exec

module.exports = (rkey-event) ->
  for f in [ Lsc, Jsc, Nop, She, Bro, But, Kfo, Ksq ] # order matters
    return if f rkey-event
