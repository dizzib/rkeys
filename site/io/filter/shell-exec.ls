_  = require \lodash
Cp = require \child_process

const DOWN = 0
const UP   = 1

module.exports = ({command, direction, id}) ->
  return false unless command?
  if _.isArray command
    command = command[direction] # explicit down/up
  else
    return unless direction is DOWN # single command on down only
  return false unless (arr = command.split ' ').0 is \exec

  cmd = (arr.slice 1) * ' '
  #log "exec #cmd"

  Cp.exec cmd, (err, stdout, stderr) ->
    log err if err
    log stdout if stdout
    log stderr if stderr

  true # handled
