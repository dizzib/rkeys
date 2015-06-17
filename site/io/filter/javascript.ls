_  = require \lodash
Vm = require \vm

const DIRECTIVE = 'javascript '

module.exports = ->
  return false unless it.command?
  return false if _.isArray it.command
  return false unless _.startsWith it.command, DIRECTIVE

  code = it.command.substring DIRECTIVE.length
  try
    log 2, cmd = Vm.runInThisContext code
    return log "must evaluate to a string command, not #cmd\n#code" unless _.isString cmd
  catch e
    log "#e\n#code"
    return true # bail

  it.command = cmd

  false # passthrough
