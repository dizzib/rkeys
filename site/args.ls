C = require \commander
_ = require \lodash
P = require \./package.json

# defaults
const APPS      = [ "#__dirname/example-app" ]
const PORT      = 7000
const VERBOSITY = 1

C.version P.version
C.usage '[Options] [directory ...]'
C.option '-g, --gen-ssl-cert', 'generate a self-signed ssl certificate'
C.option '-p, --port <port>', "listening port (default:#PORT)", PORT
C.option '-v, --verbosity <level>', "verbosity 0=min 2=max (default:#VERBOSITY)", VERBOSITY
C.allowUnknownOption! # ignore mocha args
C.parse process.argv
C.dirs = if C.args.length then C.args else APPS
C.port-ssl = 1 + _.parseInt C.port
C.verbosity = if (v = C.verbosity) in <[0 1 2]> then Math.abs _.parseInt v else 1

module.exports = C
