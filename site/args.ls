C = require \commander
P = require \./package.json

const DEFAULT-PORT   = 7000
const DEFAULT-APPDIR = "#__dirname/example"

C.version P.version
C.usage '[Options] <app-directory ...>'
C.option '-p, --port [port]', "listening port (default:#DEFAULT-PORT)", DEFAULT-PORT
C.parse process.argv
C.app-dirs = if C.args.length then C.args else [ DEFAULT-APPDIR ]
C.port-ssl = 1 + parseInt C.port, 10

module.exports = C
