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

const KEYPAD = \keypad
const DIR-KEYPAD = "#__dirname/#KEYPAD"

express
  ..set \port, Args.port
  ..set 'view engine', \jade
  ..set \views, [ DIR-KEYPAD, "#{Args.defdir}/#KEYPAD" ]
  ..use Morgan \dev
  ..get /^\/l$/, (, res) -> res.send 'todo: typey left hand'
  ..get /^\/r$/, (, res) -> res.send 'todo: typey right hand'
  ..get /^\/([A-Za-z]+)$/, (req, res) -> res.render req.params.0
  ..use Express.static DIR-KEYPAD
  ..use ErrHan!

  # allow 'extend /base' in custom keypad
  # see http://stackoverflow.com/questions/16525362/how-do-you-set-jade-basedir-option-in-an-express-app-the-basedir-option-is-r
  ..locals.basedir = DIR-KEYPAD

W4m http, \listen, Args.port
console.log "Express http server listening on port #{Args.port}"
