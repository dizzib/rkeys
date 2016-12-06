Bp = require \body-parser
D  = require \../rkey/constants .directions
R  = require \../rkey

module.exports =
  init: (express) ->
    express
      ..use Bp.text type:\application/x-www-form-urlencoded
      ..post \/api/rkeydown (req, res) ->
        R act:req.body, direction:D.DOWN
        res.send!
      ..post \/api/rkeydownup (req, res) ->
        R act:act = req.body, direction:D.DOWN
        R act:act, direction:D.UP
        res.send!
      ..post \/api/rkeyup (req, res) ->
        R act:req.body, direction:D.UP
        res.send!
