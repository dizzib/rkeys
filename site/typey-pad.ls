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
Io      = require \./io/handler

Io.init http = Http.Server (express = Express!)

const DIR-UI  = "#__dirname/ui"
const DIR-CSS = "#DIR-UI/.css"

keypad-dirs = Args.keypad-dirs ++ DIR-UI # order matters
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
express.use Express.static DIR-UI

# keypads stylus overrides base
for d in Args.keypad-dirs then set-stylus d
set-stylus DIR-UI

express
  ..use ErrHan!
  # allow 'extend /base' in custom keypad
  # see http://stackoverflow.com/questions/16525362/how-do-you-set-jade-basedir-option-in-an-express-app-the-basedir-option-is-r
  ..locals.basedir = DIR-UI

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
        .set \paths, [ dir, DIR-UI ] # allow '@require mixins'
        .use Nib!
  express.use Express.static dir-css
