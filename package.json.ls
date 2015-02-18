name       : \rkeys
version    : \0.3.0
description: "Quickly create tablet apps to send keystrokes to remote Linux"
keywords   : <[ chord control key keyboard keypad linux macro mobile remote tablet touch virtual ]>
homepage   : \https://github.com/dizzib/rkeys
bugs       : \https://github.com/dizzib/rkeys/issues
license:   : \MIT
author     : \dizzib
bin        : \./bin/rkeys
repository :
  type: \git
  url : \https://github.com/dizzib/rkeys
engines:
  node: '>=0.10.x'
  npm : '>=1.0.x'
dependencies:
  browserify   : \8.1.3
  commander    : \2.6.0
  errorhandler : \1.3.2
  express      : \4.11.1
  jade         : \1.9.1
  'js-yaml'    : \3.2.5
  LiveScript   : \1.3.0
  lodash       : \2.4.1
  lsify        : \0.1.0
  morgan       : \1.5.1
  nib          : \1.1.0
  shelljs      : \0.3.0
  'socket.io'  : \1.3.2
  stylus       : \0.49.3
  'wait.for'   : \0.6.3
  x11          : \1.0.2
devDependencies:
  chalk        : \~0.4.0
  cron         : \~1.0.3
  gaze         : \~0.6.4
  globule      : \~0.2.0 # TODO: remove when gaze fixes issue 104
  gntp         : \~0.1.1
  marked       : \~0.3.1
