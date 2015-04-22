Assert  = require \assert
Choki   = require \chokidar
Cron    = require \cron
Emitter = require \events .EventEmitter
Fs      = require \fs
_       = require \lodash
Md      = require \marked
Path    = require \path
Shell   = require \shelljs/global
WFib    = require \wait.for .launchFiber
W4      = require \wait.for .for
W4m     = require \wait.for .forMethod
Dir     = require \./constants .dir
Dirname = require \./constants .dirname
G       = require \./growl

const NMODULES = './node_modules'

pruner = new Cron.CronJob cronTime:'*/10 * * * *', onTick:prune-empty-dirs
tasks  =
  livescript:
    cmd : "#NMODULES/LiveScript/bin/lsc --output $OUT $IN"
    ixt : \ls
    oxt : \js
    xsub: 'json.js->json'
  markdown:
    cmd : markdown
    ixt : \md
    oxt : \html
  static:
    cmd : 'cp --target-directory $OUT $IN'
    pat : '{rkeys,*.{css,eot,jade,js,otf,styl,svg,ttf,wav,woff,woff2,yaml}}'

module.exports = me = (new Emitter!) with
  all: ->
    try
      for tid of tasks then compile-batch tid
      me.emit \built
    catch e then G.err e

  delete-files: ->
    log "delete-files #{pwd!}"
    Assert.equal pwd!, Dir.BUILD
    W4 exec, "bash -O extglob -O dotglob -c 'rm -rf !(node_modules|task)'"

  delete-modules: ->
    log "delete-modules #{pwd!}"
    Assert.equal pwd!, Dir.BUILD
    rm '-rf' "./node_modules"

  refresh-modules: ->
    Assert.equal pwd!, Dir.BUILD
    W4 exec, 'npm -v'
    W4 exec, 'npm prune'
    W4 exec, 'npm install'

  start: ->
    G.say 'build started'
    try
      pushd Dir.ROOT
      for tid of tasks then start-watching tid
    finally
      popd!
    pruner.start!

  stop: ->
    pruner.stop!
    for , t of tasks then t.watcher?close!
    G.say 'build stopped'

## helpers

function compile t, ipath, cb
  Assert.equal pwd!, Dir.BUILD
  ipath-abs = Path.resolve Dir.ROOT, ipath
  odir = Path.dirname opath = get-opath t, ipath
  mkdir \-p, odir # stylus fails if outdir doesn't exist
  switch typeof t.cmd
  | \string =>
    cmd = t.cmd.replace(\$IN, "'#ipath-abs'").replace \$OUT, "'#odir'"
    log cmd
    code, res <- exec cmd
    log code, res if code
    cb (if code then res else void), opath
  | \function =>
    e <- t.cmd ipath-abs, opath
    cb e, opath

function compile-batch tid
  t = tasks[tid]
  w = t.watcher._watched
  # https://github.com/paulmillr/chokidar/issues/281
  files = [ p-abs for p, v of w for f of v._items
    when test \-f p-abs = Path.join p, f ]
  info = "#{files.length} #tid files"
  G.say "compiling #info..."
  for f in files then W4 compile, t, Path.relative Dir.ROOT, f
  G.ok "...done #info!"

function get-opath t, ipath
  p = ipath.replace t.ixt, t.oxt if t.ixt?
  return p or ipath unless (xsub = t.xsub?split '->')?
  p.replace xsub.0, xsub.1

function markdown ipath, opath, cb
  e, html <- Md cat ipath
  html.to opath unless e?
  cb e

function prune-empty-dirs
  unless pwd! is Dir.BUILD then return log 'bypass prune-empty-dirs'
  code, out <- exec "find . -type d -empty -delete"
  G.err "prune failed: #code #out" if code

function start-watching tid
  log "start watching #tid"
  Assert.equal pwd!, Dir.ROOT
  pat = (t = tasks[tid]).pat or "*.#{t.ixt}"
  dirs = "#{Dirname.SITE},#{Dirname.TASK}"
  w = t.watcher = Choki.watch [ "{#dirs}/**/#pat" pat ],
    cwd:Dir.ROOT
    ignoreInitial:true
    ignored:"#{Dirname.SITE}/app/*.*"
  w.on \all _.debounce process, 500ms, leading:true trailing:false

  function process act, ipath
    log act, tid, ipath
    <- WFib
    switch act
      | \add, \change
        try opath = W4 compile, t, ipath
        catch e then return G.err e
        G.ok opath
        me.emit \built
      | \unlink
        Assert.equal pwd!, Dir.BUILD
        try W4m Fs, \unlink, opath = get-opath t, ipath
        catch e then throw e unless e.code is \ENOENT # not found i.e. already deleted
        G.ok "Delete #opath"
        me.emit \built
