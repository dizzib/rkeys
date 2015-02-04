## rkeys

Setup virtual keypads to control Linux remotely from a tablet:

- define keypads with a bit of [jade] and [stylus]
- define macros in [YAML] with optional delays and auto-repeat
- simulate raw key press and release
- trigger shell exec
- use [Font Awesome][fa] icons
- built on [Express] and [node.js]

## install and run

On the Linux box to be controlled:

    $ npm install rkeys

    $ cd node_modules/rkeys
    $ node rkeys ./example

Navigate your tablet to `http://server:7000/keypad` where `server` is
the node.js server running rkeys.

## define custom keypads

TODO

## options

    $ node rkeys --help
    Usage: rkeys [options] <app-directory ...>

    Options:

      -h, --help             output usage information
      -V, --version          output the version number
      -p, --port [port]      listening port (default:7000)

## rkeys apps

[megapad](https://github.com/dizzib/megapad)

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
[fa]: http://fortawesome.github.io/Font-Awesome/
[jade]: http://jade-lang.com
[LiveScript]: https://github.com/gkz/LiveScript
[node.js]: http://nodejs.org
[stylus]: https://learnboost.github.io/stylus
[YAML]: https://en.wikipedia.org/wiki/YAML
