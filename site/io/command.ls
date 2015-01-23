Fs   = require \fs
Yaml = require \js-yaml
Sh   = require \shelljs/global
Args = require \../args

const FNAME = \command.yaml

yaml = Fs.readFileSync "#__dirname/#FNAME"

if test \-e, fpath = "#{Args.defdir}/io/#FNAME"
  log "load yaml from #fpath"
  yaml += Fs.readFileSync fpath

cmds = Yaml.safeLoad yaml
log cmds

module.exports.get = (id) -> cmds[id]

