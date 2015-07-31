_     = require \lodash
Cp    = require \child_process
Shell = require \shelljs/global
Dir   = require \./constants .dir
G     = require \./growl

const DIRBIN = "#{Dir.ROOT}/node_modules/.bin"
const ISTANB = "#DIRBIN/istanbul cover #DIRBIN/_mocha"
const M-ARGS = "--timeout 5000 --reporter spec --bail --colors 'test/**/*.js'"
const CMD    = "#ISTANB -- #M-ARGS"

module.exports =
  exec: ->
    exec CMD
  run: (cb) ->
    v = exec 'node --version' silent:true .output - '\n'
    log "run tests in node #v"
    err, sout, serr <- Cp.exec CMD, cwd:Dir.BUILD
    log sout
    tail = sout.slice -750
    G.ok "All tests passed\n\n#tail" nolog:true unless err
    G.alert "Tests failed\n\n#tail" nolog:true if err
    return unless _.isFunction cb
    cb err
