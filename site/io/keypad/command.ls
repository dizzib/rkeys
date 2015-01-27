Fs   = require \fs
Yaml = require \js-yaml
Sh   = require \shelljs/global
Args = require \../../args

const FNAME = \command.yaml

fpath = "#{Args.custom-defs-dir}/io/#FNAME"
cmds = load!

Fs.watchFile fpath, ->
  cmds := load!

module.exports.get = (id) -> cmds[id]

function load
  yaml = Fs.readFileSync "#__dirname/#FNAME"
  if test \-e, fpath
    log "load yaml from #fpath"
    yaml += Fs.readFileSync fpath
  (Yaml.safeLoad yaml) or []
