Fs   = require \fs
_    = require \lodash
Yaml = require \js-yaml
Sh   = require \shelljs/global
Args = require \../args

fpaths = get-yaml-paths!
cmds   = load!
for p in fpaths then Fs.watchFile p, -> cmds := load!

module.exports.get = (id) -> cmds[id]

## helpers

function apply-aliases aliases, s
  for ak, av of aliases then s = s.replace ak, av
  s

function get-yaml-paths
  # order matters: later yaml overrides earlier, so load the core
  # rkeys yaml first so it can be overridden by apps.
  dirs  = [ __dirname ] ++ Args.app-dirs
  _.flatten [ls "#d/*.yaml" for d in dirs]

function load
  yaml = ''
  for p in fpaths
    if test \-e, p
      log "load commands from #p"
      yaml += Fs.readFileSync p
  cfg = (Yaml.safeLoad yaml) or []

  # process aliases
  cmds = {}
  as = {}
  for k, v of cfg
    if /^alias /.test v then as[k] = v.slice 6 else cmds[k] = v
  for k, v of cmds
    if _.isArray v
      cmds[k] = []
      for s in v then cmds[k].push apply-aliases as, s
    else if _.isString v
      cmds[k] = apply-aliases as, v
  cmds
