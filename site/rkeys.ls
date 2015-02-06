global.log = console.log

<- require \wait.for .launchFiber

Bify    = require \browserify
ErrHan  = require \errorhandler
Express = require \express
Http    = require \http
Lsify   = require \lsify
Morgan  = require \morgan
Nib     = require \nib
Shell   = require \shelljs/global
Stylus  = require \stylus
W4m     = require \wait.for .forMethod
Args    = require \./args
Io      = require \./io/handler

Io.init http = Http.Server (express = Express!)

const DIR-UI  = "#__dirname/ui"
const DIR-CSS = "#DIR-UI/.css"

app-dirs = Args.app-dirs ++ DIR-UI # order matters
log "app directories: #{app-dirs * ' '}"

express
  ..set \port, Args.port
  ..use Morgan \dev
  # jade
  ..set 'view engine', \jade
  ..set \views, app-dirs # order matters
  ..get /^\/([_A-Za-z\-\/]+)$/, (req, res) -> res.render req.params.0

# 3rd-party library js, css, etc are served by these static handlers
for d in Args.app-dirs then express.use Express.static d
# apps statics take precedence over rkeys statics
express.use Express.static DIR-UI

for d in Args.app-dirs
  use-livescript d
  use-stylus d
use-stylus DIR-UI

express
  ..use ErrHan!
  # allow 'extend /base' in apps
  # see http://stackoverflow.com/questions/16525362/how-do-you-set-jade-basedir-option-in-an-express-app-the-basedir-option-is-r
  ..locals.basedir = DIR-UI

W4m http, \listen, Args.port
console.log "Express http server listening on port #{Args.port}"

## helpers

function use-livescript dir
  express.use "*.js", (req, res, next) ->
    return next! unless test \-e, lspath = "#dir#{req.params.0}.ls"
    b = Bify lspath, basedir:dir
    log "compile #lspath"
    (err, buf) <- b.transform Lsify .bundle
    return next err if err
    res.send buf.toString!

function use-stylus dir
  express.use Stylus.middleware do
    src    : dir
    dest   : dir-css = "#dir/.css"
    compile: (str, path) ->
      Stylus(str)
        .set \filename, path
        .set \paths, [ dir, DIR-UI ] # allow @require of rkeys mixins
        .use Nib!
  express.use Express.static dir-css
