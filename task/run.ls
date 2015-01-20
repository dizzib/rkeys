_     = require \lodash
Chalk = require \chalk
Cp    = require \child_process
Shell = require \shelljs/global
Cfg   = require \./config
Dir   = require \./constants .dir
G     = require \./growl

module.exports =
  recycle-site: ->
    <- stop-site Cfg
    <- start-site Cfg

## helpers

function get-site-desc cfg
  "typey-pad@#{cfg.PORT}"

function get-start-site-args cfg
  "#{cfg.NODE_ARGS or ''} boot #{get-site-desc cfg}".trim!

function kill-node args, cb
  # can't use WaitFor as we need the return code
  code, out <- exec cmd = "pkill -ef 'node #{args.replace /\*/g, '\\*'}'"
  # 0 One or more processes matched the criteria.
  # 1 No processes matched.
  # 2 Syntax error in the command line.
  # 3 Fatal error: out of memory etc.
  throw new Error "#cmd returned #code" if code > 1
  cb!

function start-site cfg, cb
  const RX-ERR = /(expected|error|exception)/i
  v = exec 'node --version', silent:true .output.replace '\n', ''
  cwd = Dir.build.SITE
  desc = get-site-desc cfg
  args = get-start-site-args cfg
  log "start site in node #v: #args"
  return log "unable to start non-existent site at #cwd" unless test \-e, cwd
  Cp.spawn \node, (args.split ' '), cwd:cwd, env:env with cfg
    ..stderr.on \data, ->
      log-data s = it.toString!
      # data may be fragmented, so only growl relevant packet
      if RX-ERR.test s then G.alert "#desc\n#s", nolog:true
    ..stdout.on \data, ->
      log-data it.toString!
      cb! if cb and /listening on port/.test it

  function log-data
    log Chalk.gray "#{Chalk.underline desc} #{it.slice 0, -1}"

function stop-site cfg, cb
  args = get-start-site-args cfg
  log "stop site: #args"
  <- kill-node args
  cb!
