## rkeys

Create mobile apps to send keystrokes to remote Linux:

- [define keypads](./site/app) with a bit of [jade] and [stylus]
- [define chords and sequences](./site/app/example.yaml) with delays and auto-repeat
- use [mixins](./site/ui/mixin) and [templates](./site/ui/template) to minimise your code
- enhance with [LiveScript] and [Font Awesome][fa] icons

## install

On the target Linux box:

    $ npm install -g rkeys

## run examples

    $ rkeys

Navigate your tablet to `http://server:7000/example` where `server`
is the target Linux server (see [example code](./site/app)).

Also try the numeric keypad at `http://server:7000/numeric`.

## options

    $ rkeys --help
    Usage: rkeys [options] <app-directory ...>

    Options:

      -h, --help             output usage information
      -V, --version          output the version number
      -p, --port [port]      listening port (default:7000)

## rkeys apps

- [megapad](https://github.com/dizzib/megapad)
- [speakeys](https://github.com/dizzib/speakeys)

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
[YAML]: https://en.wikipedia.org/wiki/YAML
