name       : \rkeys
version    : \0.11.0
description: "A platform for creating tablet/HTML5 virtual-keyboard apps to send keystrokes to remote X11"
keywords   : [\chord \chords \key \keyboard \keypad \keys \keystroke \macro 'remote control' \tablet 'virtual keyboard' \X11]
homepage   : \https://github.com/dizzib/rkeys
bugs       : \https://github.com/dizzib/rkeys/issues
license:   : \MIT
author     : \dizzib
bin        : \./bin/rkeys
repository :
  type: \git
  url : \https://github.com/dizzib/rkeys
scripts:
  start: './task/bootstrap && node ./_build/task/repl'
  test : './task/bootstrap && node ./_build/task/npm-test'
dependencies:
  browserify   : \8.1.3
  commander    : \2.6.0
  errorhandler : \1.3.2
  express      : \4.11.1
  jade         : \1.9.2
  'js-yaml'    : \3.2.5
  LiveScript   : \1.3.0
  lodash       : \3.5.0
  lsify        : \0.1.0
  marked       : \0.3.3
  morgan       : \1.5.1
  nib          : \1.1.0
  shelljs      : \0.3.0
  'socket.io'  : \1.3.5
  stylus       : \0.49.3
  'wait.for'   : \0.6.3
  x11          : \1.0.3
devDependencies:
  chai         : \~3.0.0
  chalk        : \~0.4.0
  chokidar     : \1.0.3 # 1.0.4 regresses
  cron         : \~1.0.3
  gntp         : \~0.1.1
  istanbul     : \~0.3.13
  lolex        : \~1.2.1
  mocha        : \~2.2.5
  mockery      : \~1.4.0
engines:
  node: '>=0.10.x'
  npm : '>=1.0.x'
preferGlobal: true
