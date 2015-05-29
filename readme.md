## rkeys

A platform for creating tablet/HTML5 virtual-keyboard apps to send keystrokes to remote [X11]:

- [define virtual keyboards or keypads][teslapad] with a bit of [jade] and [stylus]
- [define chords and sequences](./site/example-app/command.yaml) with delays and auto-repeat
- use the built-in [mixins](./site/ui/mixin) and [templates](./site/ui/template) to minimise your code
- enhance with [LiveScript] and [Font Awesome][fa] icons
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

Extending the [keys template](./site/ui/template/keys.jade)
gives us access to the handy [+key and +keys mixins](./site/ui/mixin/keys.jade).
Host the app by passing its directory on the rkeys command line `$ rkeys foo`
then navigate your tablet to `http://your-rkeys-server:7000/bar`:

![tutorial screenshot](http://dizzib.github.io/rkeys/tutorial.png)

## base template

The [base template] is the foundation of rkeys apps and includes the JavaScript
libraries [socket.io] to communicate the user's keystrokes to the server,
[jquery] to dynamically manipulate the user interface and
[lodash] for general purpose functions.
It includes the following [jade mixins](./site/ui/mixin/base.jade):

usage | purpose
------|--------
+prevent-zoom | lock the zoom-level to prevent accidental pinch-zoom. Should be placed in the head section.
+show-if(activeWindowTitle='**regexp**') | only show content if the active window title matches the [regular expression] **regexp**.

In addition the following [stylesheet classes](./site/ui/template/base.styl)
are available for manipulating layouts:

usage | purpose
------|--------
.layout.**id** | only show content when layout is switched by command `layout:id`. The default id is **default**.
.horizontal | arrange immediate children horizontally
.vertical | arrange immediate children vertically

## keys template

todo

## command configuration YAML

The default behaviour of `+key('a')` is to simulate a KeyPress 'a' event on
touchstart and a KeyRelease 'a' event on touchend.
This allows you to press and hold the key to get native auto-repeat
and even applies to key chords such as `+key('C+S+A+z')`.

The `+key` mixin can also accept a custom command-id where the
command itself is defined in a YAML file (typically `command.yaml`)
in the app's directory.
For example, `+key('foo')` will run the following command which is
a macro emitting keystrokes `b`, `a` and `r`:

    foo: b a r

Commands can also take parameters, so the above can be rewritten as
`foo: $0 $1 $2` and invoked by `+key('foo:b,a,r')`.

### filters

The first word of a command can specify a filter to alter the functionality:

id: command | what it does
------------|-------------
ID: **alias** *str* | replace all occurrences of `ID` with *str* in the YAML. The standard naming convention is all capitals.
id: **broadcast** *msg* | broadcast *msg* to all connected clients. Useful for multi-tablet setups.
id: **button** *n* | simulate mouse button *n*
id: **exec** *cmd* | execute shell command *cmd*
id: **nop** | no-operation. Useful as a placeholder to be redefined at runtime.

### example of redefining commands at runtime

    $ rkeys ./app1 ./app2 ~/user-commands

Command YAMLs are loaded in order, so YAML in `~/user-commands` can
override that of app1 or app2.

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

The built-in `SFX-` aliases are defined [here](./site/io/command.yaml)
but you can always supply your own soundfiles (note that relative paths are relative
to the source file).
You should redefine the `PLAY-SOUND` alias to match your own system. So with [SoX]
installed you could include the following to play sounds at quarter volume:

    PLAY-SOUND: alias exec play -V1 -q --volume 0.25

## options

    $ rkeys --help
    Usage: rkeys [options] <directory ...>

    Options:

      -h, --help             output usage information
      -V, --version          output the version number
      -g, --gen-ssl-cert     generate a self-signed ssl certificate
      -p, --port [port]      listening port (default:7000)

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

MIT

[base template]: ./site/ui/template/base.jade
[ComposeKey]: https://help.ubuntu.com/community/ComposeKey#Compose%20key%20sequences
[Express]: http://expressjs.com
[chords]: https://en.wikipedia.org/wiki/Chorded_keyboard
[fa]: http://fortawesome.github.io/Font-Awesome/
[jade]: http://jade-lang.com
[jquery]: http://jquery.com
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
[YAML]: https://en.wikipedia.org/wiki/YAML
