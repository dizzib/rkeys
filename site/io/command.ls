Fs   = require \fs
Path = require \path
_    = require \lodash
Yaml = require \js-yaml
Sh   = require \shelljs/global
Args = require \../args

aliases = {}
cmds    = {}
fpaths  = []

module.exports = me =
  apply-aliases: (s) ->
    for k, v of aliases then s = s.replace k, v
    s
  get: (id) -> cmds[id]

load-all!

function load-all
  for p in fpaths then Fs.unwatchFile p
  # order matters: later yaml overrides earlier, so load the
  # rkeys yaml first so it can be overridden by apps.
  dirs  = [ __dirname ] ++ Args.dirs
  fpaths := _.flatten [ls "#d/*.yaml" for d in dirs]

  cfg = {}
  for p in fpaths
    cfg = _.extend cfg, load-file p
    Fs.watchFile p, load-all
  process-aliases cfg

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
  aliases := {}
  cmds    := {}
  for k, v of cfg
    if /^alias /.test v then aliases[k] = v.slice 6 else cmds[k] = v
  for k, v of cmds
    if _.isArray v
      cmds[k] = []
      for s in v then cmds[k].push me.apply-aliases s
    else if _.isString v
      cmds[k] = me.apply-aliases v
