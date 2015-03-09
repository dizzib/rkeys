_  = require \lodash
Cp = require \child_process

const DOWN = 0
const UP   = 1

module.exports = (direction, id, command) ->
  return false unless _.isString command
  return false unless (arr = command.split ' ').0 is \exec
  return true if direction is UP

  cmd = (arr.slice 1) * ' '
  #log "exec #cmd"

  Cp.exec cmd, (err, stdout, stderr) ->
    log err if err
    log stdout if stdout
    log stderr if stderr

  true # handled
