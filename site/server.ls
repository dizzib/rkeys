require \./log
return (require \./gen-ssl-cert)! if (Args = require \./args).gen-ssl-cert

Bify    = require \browserify
ErrHan  = require \errorhandler
Express = require \express
Fs      = require \fs
Http    = require \http
Https   = require \https
Lsify   = require \lsify
Morgan  = require \morgan
Nib     = require \nib
Path    = require \path
Shell   = require \shelljs/global
Stylus  = require \stylus

err <- (require \./io/x11/boot)!
return log err if err

Api-http = require \./io/api/http
Api-ws   = require \./io/api/ws

log "dirs: #{Args.dirs * ' '}"
dirs = Args.dirs ++ const DIR-UI = "#__dirname/ui" # order matters
dirs = dirs ++ __dirname if process.env.NODE_ENV is \development

express = Express!
  ..set \port Args.port
  ..use Morgan \dev
  # jade
  ..set 'view engine' \jade
  ..set \views dirs # order matters
  ..get /^\/([_A-Za-z\-\/]+)$/ (req, res) -> res.render req.params.0

# 3rd-party library js, css, etc are served by these static handlers
for d in Args.dirs then express.use Express.static d
# apps statics take precedence over rkeys statics
express.use Express.static DIR-UI

for d in Args.dirs
  use-livescript d
  use-stylus d
use-stylus DIR-UI

express
  ..use ErrHan!
  # allow 'extend /base' in apps
  # see http://stackoverflow.com/questions/16525362/how-do-you-set-jade-basedir-option-in-an-express-app-the-basedir-option-is-r
  ..locals.basedir = DIR-UI

start-http (err, s0) ->
  return log err if err
  err, s1 <- start-https
  return log err if err
  Api-http.init express
  Api-ws.init [s0, s1]

## helpers

function start-http cb
  s = Http.createServer express
  err <- s.listen p = Args.port
  log0 "Express http server listening on port #p" unless err
  cb err, s

function start-https cb
  keys  = ls [ Path.join d, '/*key.pem' for d in Args.dirs ]
  certs = ls [ Path.join d, '/*cert.pem' for d in Args.dirs ]
  return cb! unless keys.length and certs.length
  log "found ssl key #{key-path = keys.0}"
  log "found ssl cert #{cert-path = certs.0}"
  key  = Fs.readFileSync key-path
  cert = Fs.readFileSync cert-path
  s = Https.createServer (key:key, cert:cert), express
  err <- s.listen p = Args.port-ssl
  log0 "Express https server listening on port #p" unless err
  cb err, s

function use-livescript dir
  express.use "*.js" (req, res, next) ->
    lspath = Path.resolve Path.join dir, "#{req.params.0}.ls"
    return next! unless test \-e lspath
    b = Bify lspath, { basedir:dir, paths:[ DIR-UI ]}
    log "compile #lspath"
    (err, buf) <- b.transform Lsify .bundle
    return next err if err
    res.send buf.toString!

function use-stylus dir
  express.use Stylus.middleware do
    src    : dir
    dest   : dir-css = "/tmp/rkeys/#dir/css"
    compile: (str, path) ->
      Stylus(str)
        .set \filename path
        .set \paths [ dir, DIR-UI ] # allow @require of rkeys mixins
        .use Nib!
  express.use Express.static dir-css
