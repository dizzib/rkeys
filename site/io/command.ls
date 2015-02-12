Fs   = require \fs
Path = require \path
_    = require \lodash
Yaml = require \js-yaml
Sh   = require \shelljs/global
Args = require \../args

var cmds
fpaths = get-yaml-paths!
load-all!
for p in fpaths then Fs.watchFile p, load-all

module.exports.get = (id) -> cmds[id]

## helpers

function get-yaml-paths
  # order matters: later yaml overrides earlier, so load the
  # rkeys yaml first so it can be overridden by apps.
  dirs  = [ "#__dirname/commands" ] ++ Args.app-dirs
  _.flatten [ls "#d/*.yaml" for d in dirs]

function load-all
  cfg = {}
  for p in fpaths then cfg = _.extend cfg, load-file p
  cmds := process-aliases cfg

function load-file path
  log "load commands from #path"
  cfg = Yaml.safeLoad Fs.readFileSync path
  return apply-includes cfg

  function apply-includes cfg
    for k, v of cfg
      if k is \include
        log "include #v"
        delete cfg.include
        paths = (v - \,).split ' '
        for prel in paths
          p = Path.resolve (Path.dirname path), prel
          cfg = _.extend cfg, load-file p
    cfg

function process-aliases cfg
  as = {} # aliases
  cs = {} # non-alias commands
  for k, v of cfg
    if /^alias /.test v then as[k] = v.slice 6 else cs[k] = v
  for k, v of cs
    if _.isArray v
      cs[k] = []
      for s in v then cs[k].push apply-aliases as, s
    else if _.isString v
      cs[k] = apply-aliases as, v
  return cs

  function apply-aliases aliases, s
    for k, v of aliases then s = s.replace k, v
    s
