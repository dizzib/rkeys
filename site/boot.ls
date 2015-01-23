global.log = console.log

<- require \wait.for .launchFiber

ErrHan  = require \errorhandler
Express = require \express
Http    = require \http
Morgan  = require \morgan
Shell   = require \shelljs/global
W4m     = require \wait.for .forMethod
Keypad  = require \./io/keypad

Keypad.init http = Http.Server (express = Express!)

const PATH_KEYPAD = "#{__dirname}/keypad"
const PATH_USER_KEYPAD = "#{env.HOME}/.typey-pad/keypad"

express
  ..set \port, env.PORT || 7000
  ..set 'view engine', \jade
  ..set \views, PATH_USER_KEYPAD

  # allow 'extend /keypad/base' in user keypad
  # see http://stackoverflow.com/questions/16525362/how-do-you-set-jade-basedir-option-in-an-express-app-the-basedir-option-is-r
  ..locals.basedir = __dirname

  ..use Morgan \dev
  ..get /^\/([A-Za-z]+)$/, (req, res) -> res.render req.params.0
  ..use Express.static PATH_KEYPAD
  ..use ErrHan!

W4m http, \listen, port = express.settings.port
console.log "Express http server listening on port #{port}"
