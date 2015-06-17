_  = require \lodash
Ls = require \LiveScript

const DIRECTIVE = 'livescript '

module.exports = ->
  return false unless it.command?
  return false if _.isArray it.command
  return false unless _.startsWith it.command, DIRECTIVE

  code = it.command.substring DIRECTIVE.length
  try
    log 2, js = Ls.compile code, bare:true header:false
  catch e
    log "#e\n#code"
    return true # bail

  it.command = "javascript #js"

  false # passthrough
