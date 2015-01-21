global.log = console.log

Express  = require \express
Http     = require \http
HttpCode = require \http-status
WFib     = require \wait.for .launchFiber
W4m      = require \wait.for .forMethod

<- WFib

Keypad = require \./io/keypad

express = Express!
http = Http.Server express
Keypad.init http

env = express.settings.env

express
  ..set \port, process.env.PORT || 7000
#  ..use Express.logger \dev if env in <[ development ]>
  ..use Express.bodyParser!
#  ..use express.router
  ..use Express.static "#{__dirname}/app"
  ..use handle-error
  ..use Express.errorHandler!

function handle-error err, req, res, next
  log (msg = if err.stack then err.stack else err.message)
  res.send HttpCode.INTERNAL_SERVER_ERROR, msg
  next err

W4m http, \listen, port = express.settings.port
console.log "Express server http listening on port #{port}"
