global.log = console.log

<- require \wait.for .launchFiber

ErrHan  = require \errorhandler
Express = require \express
Http    = require \http
Morgan  = require \morgan
Nib     = require \nib
Shell   = require \shelljs/global
Stylus  = require \stylus
W4m     = require \wait.for .forMethod
Keypad  = require \./io/keypad

Keypad.init http = Http.Server (express = Express!)

const PATH_KEYPAD = "#{__dirname}/keypad"
const PATH_USER_KEYPAD = "#{env.HOME}/.typey-pad/keypad"

express
  ..set \port, env.PORT || 7000
  ..set 'view engine', \jade
  ..set \views, PATH_USER_KEYPAD
  ..use Morgan \dev
#  ..use Stylus.middleware do
#    src: PATH_USER_KEYPAD
#    dest: "#PATH_USER_KEYPAD/.css"
#    compile: (src, path) ->
#      log path
#      Stylus src .set(\filename, path).use Nib!
  ..get /^\/([A-Za-z]+)$/, (req, res) -> res.render req.params.0
  ..use Express.static PATH_KEYPAD
  ..use ErrHan!

W4m http, \listen, port = express.settings.port
console.log "Express http server listening on port #{port}"

# set symlinks to let user keypads access base resources
set-symlink \base.jade
set-symlink \base.styl

function set-symlink fname
  ln \-sf, "#{__dirname}/keypad/#fname", "#PATH_USER_KEYPAD/#fname"
