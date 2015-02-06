global.log = console.log

<- require \wait.for .launchFiber

Bify    = require \browserify
ErrHan  = require \errorhandler
Express = require \express
Fs      = require \fs
Http    = require \http
Https   = require \https
Lsify   = require \lsify
Morgan  = require \morgan
Nib     = require \nib
Shell   = require \shelljs/global
Stylus  = require \stylus
W4m     = require \wait.for .forMethod
Args    = require \./args
Io      = require \./io/handler

const DIR-UI  = "#__dirname/ui"
const DIR-CSS = "#DIR-UI/.css"

log "app-dirs: #{Args.app-dirs * ' '}"

express = Express!
  ..set \port, Args.port
  ..use Morgan \dev
  # jade
  ..set 'view engine', \jade
  ..set \views, Args.app-dirs ++ DIR-UI # order matters
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

start-http!
start-https!

## helpers

function start-http
  Io.init http = Http.createServer express
  W4m http, \listen, Args.port
  log "Express http server listening on port #{Args.port}"

function start-https
  keys  = ls [ "#dir/*key.pem" for dir in Args.app-dirs ]
  certs = ls [ "#dir/*cert.pem" for dir in Args.app-dirs ]
  return unless keys.length and certs.length
  log "found ssl key #{key-path = keys.0}"
  log "found ssl cert #{cert-path = certs.0}"
  key  = Fs.readFileSync key-path
  cert = Fs.readFileSync cert-path
  Io.init https = Https.createServer (key:key, cert:cert), express
  W4m https, \listen, Args.port-ssl
  log "Express https server listening on port #{Args.port-ssl}"

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