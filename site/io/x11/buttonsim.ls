_   = require \lodash
X11 = require \x11
H   = require \./helper

module.exports =
  down: -> simulate H.xtest.ButtonPress, it
  up  : -> simulate H.xtest.ButtonRelease, it

downbids = []
process.on \exit, release-buttons

function fake-input type, bid
  H.xtest.FakeInput type, bid, 0, H.root, 0, 0

function release-buttons
  for bid in downbids
    log "release button #bid"
    fake-input H.xtest.ButtonRelease, bid

function simulate type, bid
  track-downbuttons type, bid
  fake-input type, bid

function track-downbuttons type, bid
  switch type
    case H.xtest.ButtonPress then downbids.push bid
    case H.xtest.ButtonRelease then _.pull downbids, bid
