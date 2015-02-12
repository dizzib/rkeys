Fs   = require \fs
_    = require \lodash
Yaml = require \js-yaml
Sh   = require \shelljs/global
Args = require \../args

var cmds
fpaths = get-yaml-paths!
load!
for p in fpaths then Fs.watchFile p, load

module.exports.get = (id) -> cmds[id]

## helpers

function get-yaml-paths
  # order matters: later yaml overrides earlier, so load the core
  # rkeys yaml first so it can be overridden by apps.
  dirs  = [ "#__dirname/commands" ] ++ Args.app-dirs
  _.flatten [ls "#d/*.yaml" for d in dirs]

function load
  yaml = ''
  for p in fpaths
    if test \-e, p
      log "load commands from #p"
      yaml += Fs.readFileSync p
  y = (Yaml.safeLoad yaml) or []
  cmds := process-aliases y

function process-aliases yaml
  as = {} # aliases
  cs = {} # non-alias commands
  for k, v of yaml
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
