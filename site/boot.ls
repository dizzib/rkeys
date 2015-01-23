global.log = console.log

<- require \wait.for .launchFiber

ErrHan  = require \errorhandler
Express = require \express
Http    = require \http
Morgan  = require \morgan
W4m     = require \wait.for .forMethod
Args    = require \./args
Keypad  = require \./io/keypad

Keypad.init http = Http.Server (express = Express!)

const DIR-KEYPAD = \keypad

express
  ..set \port, Args.port
  ..set 'view engine', \jade
  ..set \views, "#{Args.defdir}/#DIR-KEYPAD"
  ..use Morgan \dev
  ..get /^\/([A-Za-z]+)$/, (req, res) -> res.render req.params.0
  ..use Express.static "#__dirname/#DIR-KEYPAD"
  ..use ErrHan!

  # allow 'extend /keypad/base' in user keypad
  # see http://stackoverflow.com/questions/16525362/how-do-you-set-jade-basedir-option-in-an-express-app-the-basedir-option-is-r
  ..locals.basedir = __dirname

W4m http, \listen, Args.port
console.log "Express http server listening on port #{Args.port}"
