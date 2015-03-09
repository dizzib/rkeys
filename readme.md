## rkeys

A platform for creating tablet/HTML5 apps to send keystrokes to remote [X11]:

- [define keypads](./site/app) with a bit of [jade] and [stylus]
- [define chords and sequences](./site/app/example.yaml) with delays and auto-repeat
- use the built-in [mixins](./site/ui/mixin) and [templates](./site/ui/template) to minimise your code
- enhance with [LiveScript] and [Font Awesome][fa] icons
- context sensitivity - show/hide elements matching the active window title
- mouse buttons and shell exec

## install

On the target [X11] box:

    $ npm install -g rkeys

## run examples

    $ rkeys

then navigate your tablet to `http://your-rkeys-server-name-or-ip:7000/example`
(see [example code](./site/app)):

![screenshot](http://dizzib.github.io/rkeys/example.png)

Also see [rkeys-apps](https://github.com/dizzib/rkeys-apps) for more.

## options

    $ rkeys --help
    Usage: rkeys [options] <app-directory ...>

    Options:

      -h, --help             output usage information
      -V, --version          output the version number
      -p, --port [port]      listening port (default:7000)

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
[X11]: https://en.wikipedia.org/wiki/X_Window_System
[YAML]: https://en.wikipedia.org/wiki/YAML
