C = require \commander
_ = require \lodash
P = require \./package.json

const DEFAULT-PORT = 7000
const DEFAULT-APP  = "#__dirname/example-app"

C.version P.version
C.usage '[Options] <directory ...>'
C.option '-g, --gen-ssl-cert', 'generate a self-signed ssl certificate'
C.option '-p, --port [port]', "listening port (default:#DEFAULT-PORT)", DEFAULT-PORT
C.parse process.argv
C.dirs = if C.args.length then C.args else [ DEFAULT-APP ]
C.port-ssl = 1 + _.parseInt C.port

module.exports = C
