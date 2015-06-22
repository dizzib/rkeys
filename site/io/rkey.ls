_   = require \lodash
Cmd = require \./command
Fc  = require \./rkey/filter-chain
Sc  = require \./rkey/side-chain

module.exports = (act, direction, io) ->
  rkey-event = act:act, direction:direction
  [rkey-event.id, rkey-event.command] = parse-act act
  log 2, rkey-event
  rkey-event.io = io
  Sc rkey-event
  Fc rkey-event

function parse-act act
  cidx = act.indexOf \:
  id = if act is \: then \: else if cidx > 0 then act.substr 0 cidx else act
  p-str = if cidx > 0 then act.substr cidx + 1 else ''
  cmd = Cmd.get-command id
  return [id, cmd] unless p-str?length
  p-arr = if _.contains cmd, \$1 then p-str / \, else [p-str]
  return [id, (replace-params cmd, p-arr)] unless _.isArray cmd
  [id, [(replace-params cmd.0, p-arr), (replace-params cmd.1, p-arr)]]

function replace-params s, p-arr
  return s unless _.isString s
  for p, i in p-arr then s .= replace "$#i" p
  s
