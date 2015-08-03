_   = require \lodash
Cmd = require \./command
Fc  = require \./rkey/filter-chain
Sc  = require \./rkey/side-chain

module.exports = (rkey-event) ->
  log 2 rkey-event
  parse-act rkey-event
  Sc rkey-event
  Fc rkey-event

function parse-act
  cidx = (act = it.act).indexOf \:
  it.id = if act is \: then \: else if cidx > 0 then act.substr 0 cidx else act
  p-str = if cidx > 0 then act.substr cidx + 1 else ''
  cmd = Cmd.get-command it.id
  return it.command = cmd unless p-str?length
  it.params = p-arr = if _.contains cmd, \$1 then p-str / \, else [p-str]
  it.command = if _.isArray cmd
    [(replace-params cmd.0, p-arr), (replace-params cmd.1, p-arr)]
  else replace-params cmd, p-arr

function replace-params s, p-arr
  return s unless _.isString s
  for p, i in p-arr then s .= replace "$#i" p
  s
