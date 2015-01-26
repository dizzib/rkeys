Commdr = require \commander

Commdr
  .option '--custom-defs-dir [dir]', 'custom definitions directory'
  .option '--reggie-server-port [port]', 'reggie-server listening port for local publish'
  .parse process.argv

module.exports = Commdr
