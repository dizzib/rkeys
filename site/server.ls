global.log = console.log

<- require \wait.for .launchFiber

ErrHan  = require \errorhandler
Express = require \express
Http    = require \http
Morgan  = require \morgan
Stylus  = require \stylus
W4m     = require \wait.for .forMethod
Args    = require \./args
Keypad  = require \./io/keypad/director

Keypad.init http = Http.Server (express = Express!)

const DIR-BASE-UI     = "#__dirname/ui"
const DIR-BASE-KEYPAD = "#DIR-BASE-UI/keypad"
const DIR-BASE-CSS    = "#DIR-BASE-KEYPAD/.css"
const DIR-CUSTOM-UI   = "#{Args.custom-defs-dir}/ui"
const DIR-CUSTOM-CSS  = "#DIR-CUSTOM-UI/.css"

result = if test \-e, Args.custom-defs-dir then 'Found' else 'Unable to find'
log "#result custom definitions directory at #{Args.custom-defs-dir}"

express
  ..set \port, Args.port
  ..use Morgan \dev

  # jade
  ..set 'view engine', \jade
  ..set \views, [ DIR-CUSTOM-UI, DIR-BASE-KEYPAD ]
  ..get /^\/l$/, (, res) -> res.send 'todo: typey left hand'
  ..get /^\/r$/, (, res) -> res.send 'todo: typey right hand'
  ..get /^\/([A-Za-z\/]+)$/, (req, res) -> res.render req.params.0

  # 3rd-party library js, css, etc are served by these static handlers
  ..use Express.static DIR-CUSTOM-UI
  ..use Express.static DIR-BASE-UI

  # base stylus
  ..use Stylus.middleware do
    src    : DIR-BASE-KEYPAD
    dest   : DIR-BASE-CSS
    compile: compile-stylus
  ..use Express.static DIR-BASE-CSS

  # custom stylus
  ..use Stylus.middleware do
    src    : DIR-CUSTOM-UI
    dest   : DIR-CUSTOM-CSS
    compile: compile-stylus
  ..use Express.static DIR-CUSTOM-CSS

  ..use ErrHan!
  # allow 'extend /base' in custom keypad
  # see http://stackoverflow.com/questions/16525362/how-do-you-set-jade-basedir-option-in-an-express-app-the-basedir-option-is-r
  ..locals.basedir = DIR-BASE-KEYPAD

W4m http, \listen, Args.port
console.log "Express http server listening on port #{Args.port}"

## helpers

function compile-stylus str, path
  Stylus(str)
    .set \filename, path
    # allow '@require mixins' in custom stylus
    .set \paths, [ DIR-CUSTOM-UI, DIR-BASE-KEYPAD ]
