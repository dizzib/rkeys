_  = require \lodash
Co = require \../command
Fc = require \./filter-chain

module.exports = (e = rkey-event) ->
  scs = Co.get-sidechains!
  for id, {chain, rx} of scs when rx.test e.from
    for {rx, cmd} in chain when r = rx.exec e.act
      for submatch, i in r
        #log2 "sidechain #id #rx #cmd submatch $#i=#submatch"
        fn = -> it.replace (new RegExp "\\$#i" \g), submatch
        cmd = if _.isArray cmd then _.map cmd, fn else fn cmd
      Fc e with command:cmd
      break # handled, so bail out of this sidechain
