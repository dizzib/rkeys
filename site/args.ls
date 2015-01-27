Commdr = require \commander
P-Json = require \./package.json

# default config
const DEFDIR = "#{process.env.HOME}/.typey-pad"
const PORT   = 7000

Commdr
  .version P-Json.version
  .option '-p, --port [port]', "listening port (default:#PORT)", PORT
  .option '-d, --custom-defs-dir [dir]', "custom definitions directory (default:#DEFDIR)", DEFDIR
  .parse process.argv

module.exports = Commdr
