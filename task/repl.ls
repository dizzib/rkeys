global.log = console.log

Chalk   = require \chalk
_       = require \lodash
Rl      = require \readline
Shell   = require \shelljs/global
WFib    = require \wait.for .launchFiber
Build   = require \./build
DirBld  = require \./constants .dir.BUILD
Run     = require \./run
G       = require \./growl

const CHALKS = [Chalk.stripColor, Chalk.yellow, Chalk.red]
const COMMANDS =
  * cmd:'h    ' lev:0 desc:'help  - show commands'  fn:show-help
  * cmd:'b.a  ' lev:0 desc:'build - all'            fn:Build.all
  * cmd:'b.d  ' lev:2 desc:'build - delete'         fn:Build.delete-files
  * cmd:'b.nd ' lev:2 desc:'build - npm delete'     fn:Build.delete-modules
  * cmd:'b.nr ' lev:1 desc:'build - npm refresh'    fn:Build.refresh-modules
  * cmd:'b.r  ' lev:0 desc:'build - recycle'        fn:Run.recycle-site

config.fatal  = true # shelljs doesn't raise exceptions, so set this process to die on error
#config.silent = true # otherwise too much noise

cd DirBld # for safety, set working directory to build

for c in COMMANDS
  c.display = "#{Chalk.bold CHALKS[c.lev] c.cmd} #{c.desc}"

rl = Rl.createInterface input:process.stdin, output:process.stdout
  ..setPrompt "typey-pad >"
  ..on \line, (cmd) ->
    <- WFib
    rl.pause!
    for c in COMMANDS when cmd is c.cmd.trim!
      try c.fn rl # readline is DI'd because multiple instances causes odd behaviour
      catch e then log e
    rl.resume!
    rl.prompt!

Build.on \built, Run.recycle-site
Build.start!
Run.recycle-site!

_.delay show-help, 500ms
_.delay (-> rl.prompt!), 750ms

# helpers

function show-help
  for c in COMMANDS then log c.display
