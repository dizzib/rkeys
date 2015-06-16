_    = require \lodash
Args = require \./args

module.exports = (level, ...args) ->
  unless _.isNumber level and args?length
    args = [level] ++ args
    level = 1
  console.log ...args if level <= Args.verbosity
