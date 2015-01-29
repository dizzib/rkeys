global.log = console.log

<- require \wait.for .launchFiber

ErrHan  = require \errorhandler
Express = require \express
Http    = require \http
Morgan  = require \morgan
Nib     = require \nib
Stylus  = require \stylus
W4m     = require \wait.for .forMethod
Args    = require \./args
Keypad  = require \./io/keypad/director

Keypad.init http = Http.Server (express = Express!)

const DIR-BASE-UI     = "#__dirname/ui"
const DIR-BASE-KEYPAD = "#DIR-BASE-UI/keypad"
const DIR-BASE-CSS    = "#DIR-BASE-KEYPAD/.css"

keypad-dirs = Args.keypad-dirs ++ DIR-BASE-KEYPAD # order matters
log "keypad directories: #{keypad-dirs * ' '}"

express
  ..set \port, Args.port
  ..use Morgan \dev
  # jade
  ..set 'view engine', \jade
  ..set \views, keypad-dirs # order matters
  ..get /^\/tpl$/, (, res) -> res.send 'todo: typey left hand'
  ..get /^\/tpr$/, (, res) -> res.send 'todo: typey right hand'
  ..get /^\/([A-Za-z\/]+)$/, (req, res) -> res.render req.params.0

# 3rd-party library js, css, etc are served by these static handlers
# keypads statics override base
for d in Args.keypad-dirs then express.use Express.static d
express.use Express.static DIR-BASE-UI

# keypads stylus overrides base
for d in Args.keypad-dirs then set-stylus d
set-stylus DIR-BASE-KEYPAD

express
  ..use ErrHan!
  # allow 'extend /base' in custom keypad
  # see http://stackoverflow.com/questions/16525362/how-do-you-set-jade-basedir-option-in-an-express-app-the-basedir-option-is-r
  ..locals.basedir = DIR-BASE-KEYPAD

W4m http, \listen, Args.port
console.log "Express http server listening on port #{Args.port}"

## helpers

function set-stylus dir
  express.use Stylus.middleware do
    src    : dir
    dest   : dir-css = "#dir/.css"
    compile: (str, path) ->
      Stylus(str)
        .set \filename, path
        .set \paths, [ dir, DIR-BASE-KEYPAD ] # allow '@require mixins'
        .use Nib!
  express.use Express.static dir-css
