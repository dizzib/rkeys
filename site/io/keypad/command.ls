Fs   = require \fs
Yaml = require \js-yaml
Sh   = require \shelljs/global
Args = require \../../args

const FNAME = \command.yaml

fpaths = [ "#d/#FNAME" for d in Args.keypad-dirs ]
cmds = load!
for p in fpaths then Fs.watchFile p, -> cmds := load!

module.exports.get = (id) -> cmds[id]

function load
  # base yaml takes lowest precedence
  yaml = Fs.readFileSync "#__dirname/#FNAME"

  # later yaml overrides earlier so read in reverse order
  # e.g. in [A B C] we want A/command.yaml to take precedence
  for p in fpaths by -1
    if test \-e, p
      log "load yaml from #p"
      yaml += Fs.readFileSync p
    else
      log "cannot find #p"

  (Yaml.safeLoad yaml) or []
