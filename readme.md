## rkeys

A platform for creating tablet/HTML5 virtual-keyboard apps to send keystrokes to remote [X11]:

- [define virtual keyboards or keypads][teslapad] with a bit of [jade] and [stylus]
- [define chords and sequences](./site/example-app/command.yaml) with delays and auto-repeat
- use the built-in [mixins](./site/ui/mixin) and [templates](./site/ui/template) to minimise your code
- enhance with [LiveScript] and [Font Awesome] icons
- assign keys to dynamically switch layouts
- context sensitivity - show/hide regions matching the active window title
- simulate mouse buttons and run shell commands
- add sound effects: server-side or (experimental) client-side
- emit special characters using [compose-key sequences][ComposeKey]

## install

With [node.js] installed on the target [X11] box:

    $ npm install -g rkeys      # might need to prefix with sudo

## run examples

    $ rkeys

then navigate your tablet to `http://your-rkeys-server:7000/example`:

![example screenshot](http://dizzib.github.io/rkeys/example-app.png)

See this example's [jade](./site/example-app/example.jade), [stylus](./site/example-app/example.styl)
and [yaml](./site/example-app/command.yaml).
Also see [some real-world examples](https://github.com/dizzib/rkeys-apps).

## get started

An rkeys app is a directory containing at least one jade file.
Create file `bar.jade` in directory `foo` and add the following lines:

    extend /template/keys

    block layout
      +key('a')

Host the app by passing its directory on the rkeys command line `$ rkeys foo`
then navigate your tablet to `http://your-rkeys-server:7000/bar`:

![tutorial screenshot](http://dizzib.github.io/rkeys/tutorial.png)

## <a name="keys-template"></a>keys template

Most of the time you'll be laying out sets of keys and this is where the
[keys template] comes in handy. It extends the [base template] with the
[Font Awesome] icons along with the following:

### +key mixin

Generate a single key comprised of an action and some label text.
The action is a [keysym] with or without the `XK_` prefix,
a [chord] denoted by infix `+` symbols,
or a [command id](#command.yaml) with optional parameters.
The label text is displayed inside the key unless it contains [font awesome]
class names in which case an icon is displayed.
Some examples:

- `+key('a')`:
  emit a KeyPress `a` on touchstart and KeyRelease `a` on touchend.
  Press and hold the key for native auto-repeat.
- `+key('XK_Shift_L')`:
  simulate the left shift key by specifying an explicit [keysym].
- `+key('Shift_L')`:
  as above but with the optional `XK_` prefix dropped.
- `+key('Shift_L', 'shift')`:
  show a user-friendly label.
- `+key('Shift_L shift')`:
  as above using a shorter syntax.
- `+key('Shift_L fa-chevron-up')`:
  replace label with a nice
  [font awesome icon](http://fortawesome.github.io/Font-Awesome/icon/chevron-up).
  A label starting with `fa-` is treated as a font awesome class.
- `+key('Shift_L fa-chevron-up fa-2x')`:
  a [double size icon](http://fortawesome.github.io/Font-Awesome/examples).
  Multiple font awesome classes can be specified.
- `+key('C+S+A+F12')`:
  a [chord] emitting the KeyPress sequence `Ctrl` `Shift` `Alt` and `F12`
  on touchstart, followed by KeyRelease sequence in the same order on touchend.
  Press and hold for native auto-repeat.
- `+key('C+S+A+F12 fold all')`:
  as above but with a nice label.
- `+key('button:3')`:
  invoke the [button](#button) command with parameter `3`
  to simulate the right mouse button.
- `+key('button:3 fa-hand-o-down fa-flip-horizontal')`:
  as above but with a flipped
  [font awesome icon](http://fortawesome.github.io/Font-Awesome/icon/hand-o-down).
- `+key('layout:fn-keys')`:
  switch the [layout](#layout) to `fn-keys` across all connected clients.

See the [source code](./site/ui/mixin/keys.jade) for more details.

### +keys mixin

Generate a set of keys by invoking `+key` multiple times.
Accepts either a single space-delimited string of actions or a list of strings
to apply to `+key` in order. Any classes or attributes are applied to each `+key`.
Some examples:

* `+keys('a b').z`:
  expands to `+key('a').z` `+key('b').z`
* `+keys('a b c').z`:
  expands to `+key('a').z` `+key('b').z` `+key('c').z`
* `+keys('a', 'b').z`:
  expands to `+key('a').z` `+key('b').z`
* `+keys('a b', 'c d').z`:
  expands to `+key('a b').z` `+key('c d').z`
* `+keys('q w e r t y')`:
  expands to `+key('q')` `+key('w')` `+key('e')` `+key('r')` `+key('t')` `+key('y')`
* `+keys('layout:fn fn', 'Shift_R shift').w-3.latchable`:
  expands to `+key('layout:fn fn').w-3.latchable`
  `+key('Shift_R shift').w-3.latchable`

### styling

The [default minimal styling](./site/ui/template/keys.styl) is easily overridden
with the following mixins and stylesheet classes:

* key-color(*up*, *label-up*, *down*, *label-down*) :
  set the label-foreground and/or key-background colours when in the
  **up** or **down** states. If you only specify *up* and *label-up*
  then these colours are swapped on **down**.
  Call this mixin at the root level to apply to all keys or from
  within a selector to apply to a subset of keys.
* key-size(*k*, *gap-percent*) :
  a mixin to override the default key size and/or gap between keys.
* .key-cols-*n* :
  a set of adjacent keys will normally [float left] but you can
  apply this class to their parent to arrange them into *n* columns.
  *n* can be from 1 to 9, so `.key-cols-1` will produce a single
  vertical column of keys.
* .h-*n* :
  apply this class to a key to multiply its height by *n* where n is from 2 to 9.
  For example `+key('a').h-2` will double the key's height.
* .w-*n* :
  apply this class to a key to multiply its width by *n* where n is from 2 to 9.
  For example `+key('a').w-3` will triple the key's width.

## base template

The [base template] is the foundation of rkeys apps and includes the JavaScript
libraries [socket.io] to communicate the user's keystrokes to the server,
[jquery] to dynamically manipulate the user interface and
[lodash] for general purpose functions.
It includes the following [jade mixins](./site/ui/mixin/base.jade):

- +prevent-zoom :
  lock the zoom-level to prevent accidental pinch-zoom.
  Should be placed in the head section.
- +show-if(activeWindowTitle='*regexp*') :
  only show child content if the active window title matches the
  [regular expression] *regexp*.

In addition the following [stylesheet classes](./site/ui/template/base.styl)
are available for manipulating layouts:

- .layout.*id* :
  only show child content when the current layout's id is *id*.
  The default layout's id is **default**.
- .horizontal :
  arrange immediate children horizontally
- .vertical :
  arrange immediate children vertically

## server API

* rkeydown :
* rkeyup :
* rkeyseq :

## <a name="command.yaml"></a>command configuration yaml

You can get more fancy than single-keys and chords by defining commands
in a [yaml] file (typically `command.yaml`) placed in the app's directory.
Each definition has format `id: command` where `id` is a unique identifier
and `command` is a string specifying what to do.

### single-keys, chords and sequences

To define a sequence of keystrokes simply list them in order separated by spaces.
Sometimes a sequence might fire too quickly for all keystrokes to take effect,
for example if a slow application needs time to react.
The solution is to introduce a short pause between keystrokes, specified in milliseconds.

Examples:

- `firefox-fullscreen: F11`
  emit KeyPress `F11` on rkeydown followed by KeyRelease `F11` on rkeyup.
- `edit-copy: C+c`:
  emit KeyPress events `Ctrl` `c` on rkeydown,
  followed by KeyRelease events `Ctrl` `c` on rkeyup.
- `abc: a b c`:
  emit the keystroke sequence `a` `b` `c` on rkeydown with no auto-repeat.
- `abc-slow: a 500 b 500 c`:
  as above but with interim pauses of 0.5 seconds.
- `abc-repeat: a b c 1000`:
  emit the keystroke sequence `a` `b` `c` on rkeydown, repeating
  every second until rkeyup.
- `abc-repeat-slow: a 500 b 500 c 1000`:
  as above but with interim pauses of 0.5 seconds.
- `HelloWorld: [ H e l l o, +Shift_L w -Shift_L o r l d ]`:
  emit the keystroke sequence `H` `e` `l` `l` `o` on rkeydown and
  `W` `o` `r` `l` `d` on rkeyup.
  Explicit Keypress/KeyRelease events are denoted by prefixes `+` and `-` respectively.

### filters

The first word of a command can specify a filter to alter the functionality:

- *id*: alias *str* :
  replace all occurrences of *id* with *str* in the yaml.
  The standard naming convention for an alias *id* is all capitals.
- *id*: broadcast *msg* :
  broadcast *msg* to all connected clients on rkeydown.
  Useful for keeping things synchronised in multi-tablet setups.
- *id*: [broadcast *msg1*, broadcast *msg2*] :
  broadcast *msg1* on rkeydown and *msg2* on rkeyup.
- *id*: button *n* :
  simulate mouse button *n* by emitting a ButtonPress on rkeydown
  and ButtonRelease on rkeyup.
- *id*: exec *cmd* :
  execute shell command *cmd* on rkeydown.
- *id*: nop :
  no-operation. Useful as a placeholder to be redefined at runtime.

Examples:

* `VBOX-HOST: alias Super_R`:
  define an alias for the virtualbox host key,
  for use in other definitions like `vbox-fullscreen: VBOX-HOST+f`.
* <a name="button"></a>`button: button $0`:
  simulate mouse button $0, where 1=left, 2=middle, 3=right, etc.
  This is defined in the [core command.yaml].
* <a name="layout"></a>`layout: [broadcast layout $0, broadcast layout default]`:
  instruct connected clients to switch to layout $0 on rkeydown,
  switching back to the default on rkeyup.
  This is defined in the [core command.yaml].
* `xterm: exec xterm`:
  launch a xterm.

### overriding default configuration at runtime

When rkeys starts, the [core command.yaml] is loaded first followed by any yaml
files discovered in directories supplied on the command line in the given order.
If a command-id appears multiple times then the last one takes precedence
thus allowing default configuration to be overridden at runtime.
For example if we launch rkeys via `$ rkeys ./app-1 ./app-2 ~/.config`
then if ./app-1/cmd.yaml contains `foo: bar` and ~/.config/rkeys.yaml
contains `foo: my-custom-command` then the latter definition 'wins'.

## sidechaining server-side sound effects

The sidechain allows secondary commands to run alongside the primary
and is the best way to add low-latency server-side sound effects.
Whenever a keydown or keyup occurs the command-id is checked against
a sequence of `/regular-expression/: command` rules and only
the first matching rule will run. Here's an example:

    # sidechain in command.yaml
    /^kde/: nop                 # make kde commands silent
    /^(button|ffx)/: PLAY-SOUND SFX-BLIP
    /^layout/: [ PLAY-SOUND SFX-TICK, PLAY-SOUND SFX-TOCK ]
    /.*/: PLAY-SOUND SFX-NOISE  # everything else

The built-in `SFX-` aliases are defined in the [core command.yaml] but you can always
supply your own soundfiles (note that relative paths are relative to the source file).
You should redefine the `PLAY-SOUND` alias to match your own system. So with [SoX]
installed you could include the following to play sounds at quarter volume:

    PLAY-SOUND: alias exec play -V1 -q --volume 0.25

## options

    $ rkeys --help
    Usage: rkeys [Options] [directory ...]

    Options:

      -h, --help               output usage information
      -V, --version            output the version number
      -g, --gen-ssl-cert       generate a self-signed ssl certificate
      -p, --port <port>        listening port (default:7000)
      -v, --verbosity <level>  verbosity 0=min 2=max (default:1)

## host over https

In a new empty directory either [create a key.pem and cert.pem manually](http://stackoverflow.com/questions/10175812/how-to-create-a-self-signed-certificate-with-openssl?rq=1)
or do the following:

    $ rkeys -g      # generate using openssl. Follow the prompts.

Include this directory on the `rkeys` command line to host over
https on port + 1 (default 7001) at `https://your-rkeys-server:7001`.

## developer build and run

    $ npm install -g livescript   # ensure livescript is installed globally
    $ git clone git@github.com:dizzib/rkeys.git
    $ cd rkeys
    $ ./task/bootstrap            # compile the task runner and install dependencies
    $ node _build/task/repl       # launch the task runner
    rkeys > b.a                   # build all and run

## license

[MIT](./LICENSE)

[base template]: ./site/ui/template/base.jade
[ComposeKey]: https://help.ubuntu.com/community/ComposeKey#Compose%20key%20sequences
[core command.yaml]: ./site/io/command.yaml
[Express]: http://expressjs.com
[chord]: https://en.wikipedia.org/wiki/Chorded_keyboard
[float left]: https://developer.mozilla.org/en-US/docs/Web/CSS/float
[Font Awesome]: http://fortawesome.github.io/Font-Awesome/
[jade]: http://jade-lang.com
[jquery]: http://jquery.com
[keysym]: https://github.com/sidorares/node-x11/blob/master/lib/keysyms.js
[keys template]: ./site/ui/template/keys.jade
[LiveScript]: http://livescript.net
[lodash]: https://lodash.com
[node.js]: http://nodejs.org
[regular expression]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions
[socket.io]: http://socket.io
[SoX]: http://sox.sourceforge.net/Main/HomePage
[stylus]: https://learnboost.github.io/stylus
[teslapad]: https://github.com/dizzib/rkeys-apps/tree/master/teslapad
[X11]: https://en.wikipedia.org/wiki/X_Window_System
[yaml]: https://en.wikipedia.org/wiki/YAML
