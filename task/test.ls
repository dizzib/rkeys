_     = require \lodash
Cp    = require \child_process
Shell = require \shelljs/global
Dir   = require \./constants .dir
G     = require \./growl

module.exports.run = (cb) ->
  v = exec 'node --version' silent:true .output - '\n'
  log "run mocha in node #v"
  cmd = "#{Dir.BUILD}/node_modules/mocha/bin/mocha"
  args = "--reporter spec --bail --colors test/*.js" / ' '
  Cp.spawn cmd, args, cwd:Dir.BUILD, stdio:[ 0, void, 2 ]
    ..on \exit, ->
      G.ok "All tests passed" nolog:true unless it
      G.err "Tests failed (code=#it)" nolog:true if it
      return unless _.isFunction cb
      cb if it then new Error "Exited with code #it" else void
    ..stdout.on \data, ->
      log s = it.toString!
      # data may be fragmented so only growl relevant packet
      G.ok s, nolog:true if /(passing)/i .test s
      G.alert s, nolog:true if /(expected|error|exception)/i .test s
