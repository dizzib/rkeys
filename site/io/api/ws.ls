Aw = require \../active-window
D  = require \../rkey/constants .directions
R  = require \../rkey
S  = require \../ws/server

module.exports =
  init: (http-servers) ->
    S.init http-servers
    S.on \connect  -> Aw.emit!
    S.on \servant  -> Aw.servant.update it.act
    S.on \rkeydown -> R act:it.act, direction:D.DOWN, from:"ws #{it.ip}"
    S.on \rkeyup   -> R act:it.act, direction:D.UP  , from:"ws #{it.ip}"
