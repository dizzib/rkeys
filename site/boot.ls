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

const DIR-KEYPAD-BASE   = "#__dirname/ui/keypad"
const DIR-KEYPAD-CUSTOM = "#{Args.defdir}/keypad"

express
  ..set \port, Args.port
  ..set 'view engine', \jade
  ..set \views, [ DIR-KEYPAD-CUSTOM, DIR-KEYPAD-BASE ]
  ..use Morgan \dev
  ..get /^\/l$/, (, res) -> res.send 'todo: typey left hand'
  ..get /^\/r$/, (, res) -> res.send 'todo: typey right hand'
  ..get /^\/([A-Za-z]+)$/, (req, res) -> res.render req.params.0
  ..use Express.static DIR-KEYPAD-CUSTOM
  ..use Express.static "#__dirname/ui" # DIR-KEYPAD-BASE
  ..use ErrHan!

  # allow 'extend /base' in custom keypad
  # see http://stackoverflow.com/questions/16525362/how-do-you-set-jade-basedir-option-in-an-express-app-the-basedir-option-is-r
  ..locals.basedir = DIR-KEYPAD-BASE

W4m http, \listen, Args.port
console.log "Express http server listening on port #{Args.port}"
