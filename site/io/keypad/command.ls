Fs   = require \fs
_    = require \lodash
Yaml = require \js-yaml
Sh   = require \shelljs/global
Args = require \../../args

fdirs  = [ __dirname ] ++ Args.keypad-dirs
fpaths = [ "#d/command.yaml" for d in fdirs ]
cmds   = load!
for p in fpaths then Fs.watchFile p, -> cmds := load!

module.exports.get = (id) -> cmds[id]

## helpers

function load
  # later yaml overrides earlier so read in reverse order
  # e.g. in [A B C] we want A/command.yaml to take precedence
  yaml = ''
  for p in fpaths by -1
    if test \-e, p
      log "load yaml from #p"
      yaml += Fs.readFileSync p
    else log "cannot find #p"
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

function apply-aliases aliases, s
  for ak, av of aliases then s = s.replace ak, av
  s
