C = require \commander
P = require \./package.json

const DEFAULT-PORT = 7000

C.version P.version
C.usage '[Options] <app-directory ...>'
C.option '-p, --port [port]', "listening port (default:#DEFAULT-PORT)", DEFAULT-PORT
C.parse process.argv
C.app-dirs = C.args

module.exports = C
