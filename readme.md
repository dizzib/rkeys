## rkeys

A platform for creating tablet/HTML5 apps to send keystrokes to remote [X11]:

- [define keypads][teslapad] with a bit of [jade] and [stylus]
- [define chords and sequences](./site/example-app/command.yaml) with delays and auto-repeat
- use the built-in [mixins](./site/ui/mixin) and [templates](./site/ui/template) to minimise your code
- enhance with [LiveScript] and [Font Awesome][fa] icons
- assign keys to switch between layouts
- context sensitivity - show/hide regions matching the active window title
- simulate mouse buttons and run shell commands
- server-side or client-side (experimental) sound effects

## install

With [node.js] installed on the target [X11] box:

    $ npm install -g rkeys      # might need to prefix with sudo

## run examples

    $ rkeys

then navigate your tablet to `http://your-rkeys-server:7000/example`:

![example screenshot](http://dizzib.github.io/rkeys/example.png)

See this example [jade](./site/example-app/example.jade), [stylus](./site/example-app/example.styl)
and [yaml](./site/example-app/command.yaml).
Also see [some real-world examples](https://github.com/dizzib/rkeys-apps).

## get started

An rkeys app is a directory containing at least one jade file.

    $ mkdir foo

Create file `./foo/bar.jade` with the following content:

    extend /template/keys

    block layout
      +key('a')

Here we pull in the [keys template](./site/ui/template/keys.jade) which
gives us access to the [+key and +keys mixins](./site/ui/mixin/keys.jade).

Host the app by passing its directory on the command line:

    $ rkeys foo

then navigate your tablet to `http://your-rkeys-server:7000/bar`:

![tutorial screenshot](http://dizzib.github.io/rkeys/tutorial.png)

## sidechain and sound effects

The sidechain allows secondary commands to run alongside the primary
and is very handy for adding sound effects.
Whenever a keydown or keyup occurs the command-id is checked against
a sequence of `/regular-expression/: command` rules and only
the first matching rule will run. Here's an example:

    # sidechain
    /^kde/: nop                 # kde commands are silent
    /^(button|ffx)/: PLAY-SOUND SFX-BLIP
    /^layout/: [ PLAY-SOUND SFX-TICK, PLAY-SOUND SFX-TOCK ]
    /.*/: PLAY-SOUND SFX-NOISE  # everything else

The built-in `SFX-` aliases are defined [here](./site/io/command.yaml)
but you can always define your own. Note that relative paths are relative
to the source file.

## options

    $ rkeys --help
    Usage: rkeys [options] <directory ...>

    Options:

      -h, --help             output usage information
      -V, --version          output the version number
      -g, --gen-ssl-cert     generate a self-signed ssl certificate
      -p, --port [port]      listening port (default:7000)

Host multiple apps by specifying their directories:

    $ rkeys ./app1 ./app2 ~/user-commands

Command YAMLs are loaded in order so the `~/user-commands` directory can
hold a YAML file containing overriding commands.

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

[Express]: http://expressjs.com
[chords]: https://en.wikipedia.org/wiki/Chorded_keyboard
[fa]: http://fortawesome.github.io/Font-Awesome/
[jade]: http://jade-lang.com
[LiveScript]: http://livescript.net
[node.js]: http://nodejs.org
[stylus]: https://learnboost.github.io/stylus
[teslapad]: https://github.com/dizzib/rkeys-apps/tree/master/teslapad
[X11]: https://en.wikipedia.org/wiki/X_Window_System
[YAML]: https://en.wikipedia.org/wiki/YAML
