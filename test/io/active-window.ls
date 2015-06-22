A   = require \chai .assert
Aw  = require "../../site/io/active-window"
Xaw = require "../../site/io/x11/active-window"

describe 'active-window' ->
  beforeEach ->
    Aw.init!add-io io
    Xaw.title = 'foo'

  test 'Xaw:changed should emit active-window-changed' ->
    Xaw.emit \changed
    A.equal 'io:active-window-changed,foo' out * ' '
