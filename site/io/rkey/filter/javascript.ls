_  = require \lodash
Vm = require \vm

const DIRECTIVE = \javascript
const SANDBOX   = log:console.log, require:require, _:_

module.exports = ->
  return false unless (cmd =  it.command)?
  return false if _.isArray cmd
  return false unless _.startsWith cmd, DIRECTIVE

  code = _.trim cmd.substring DIRECTIVE.length
  try
    log 2 cmd = Vm.runInNewContext code, SANDBOX <<< params:it.params
    unless _.isString cmd
      log "must evaluate to a string command, not #cmd\n#code"
      return true # bail
  catch e
    log "#e\n#code"
    return true # bail

  it.command = cmd

  false # passthrough
