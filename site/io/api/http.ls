Bp = require \body-parser
D  = require \../rkey/constants .directions
R  = require \../rkey

module.exports =
  init: (express) ->
    express
      ..use Bp.text type:\application/x-www-form-urlencoded
      ..post \/api/rkeydown (req, res) ->
        rkey req, D.DOWN
        res.send!
      ..post \/api/rkeydownup (req, res) ->
        rkey req, D.DOWN
        rkey req, D.UP
        res.send!
      ..post \/api/rkeyup (req, res) ->
        rkey req, D.UP
        res.send!

    function rkey req, direction
      R act:req.body, direction:direction, from:"http #{req.ip}"
