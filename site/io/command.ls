Fs   = require \fs
Gaze = require \gaze
Yaml = require \js-yaml
Sh   = require \shelljs/global
Args = require \../args

const FNAME = \command.yaml

fpath = "#{Args.defdir}/io/#FNAME"
cmds = load!

Gaze fpath, ->
  act, path <- @on \all
  log act, path
  cmds := load!

module.exports.get = (id) -> cmds[id]

function load
  yaml = Fs.readFileSync "#__dirname/#FNAME"
  if test \-e, fpath
    log "load yaml from #fpath"
    yaml += Fs.readFileSync fpath
  cmds = Yaml.safeLoad yaml
  #log cmds
  cmds
