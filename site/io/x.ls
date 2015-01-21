X11  = require \x11
W4m  = require \wait.for .forMethod

const KEYCODES =
  Bksp : 22
  Shift: 50
  A    : 38
  B    : 56
  F7   : 73

disp = W4m X11, \createClient
root = disp.screen.0.root
dc = disp.client
dc.on \error, -> log \error, it
xt = W4m dc, \require, \xtest

module.exports =
  keydown: -> fake-input xt.KeyPress, it
  keyup  : -> fake-input xt.KeyRelease, it

function fake-input direction, keyid
  xt.FakeInput direction, KEYCODES[keyid], 0, root, 0, 0
