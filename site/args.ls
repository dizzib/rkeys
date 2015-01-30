C = require \commander
P = require \./package.json

const DEFAULT-PORT        = 7000
const DEFAULT-KEYPADS-DIR = "#__dirname/examples"

C.version P.version
C.usage '[Options] <keypad-directory ...>'
C.option '-p, --port [port]', "listening port (default:#DEFAULT-PORT)", DEFAULT-PORT
C.parse process.argv
C.keypad-dirs = C.args
C.keypad-dirs.push DEFAULT-KEYPADS-DIR unless C.keypad-dirs.length

module.exports = C
