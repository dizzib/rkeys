## rkeys

Setup virtual keypads to control Linux from a remote tablet:

- define keypads with a bit of [jade] and [stylus]
- define macros in [YAML] with optional delays and auto-repeat
- enhance with [LiveScript] and [Font Awesome][fa] icons
- simulate raw key press and release
- [chords] on multi-touch tablets

## install

On the Linux box to be controlled:

    $ npm install -g rkeys

## run example

    $ rkeys

Navigate your tablet to `http://server:7000/example`
where `server` is the node.js server running rkeys
(see [example code](https://github.com/dizzib/rkeys/tree/master/site/app)).

## define custom keypads

TODO

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
