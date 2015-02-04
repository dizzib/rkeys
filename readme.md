## rkeys


## install and run

    $ npm install rkeys
    $ cd node_modules/rkeys
    $ node rkeys

## options

    $ node rkeys --help
    Usage: rkeys [options]

    Options:

      -h, --help             output usage information
      -V, --version          output the version number
      -p, --port [port]      listening port (default:7000)

## usage

Navigate to `http://server:7000` where `server` is
the node.js server running rkeys.

## examples


## build and run locally

    $ git clone git@github.com:dizzib/rkeys.git

    $ npm install -g livescript   # ensure livescript is installed globally
    $ ./task/bootstrap            # compile the task runner and install dependencies
    $ node dist/task/repl         # launch the task runner
    rkeys > b.fc                  # compile everything

    $ node _build/site/rkeys      # run it!

## license

MIT

[express]: https://github.com/visionmedia/express
[LiveScript]: https://github.com/gkz/LiveScript
[node.js]: http://nodejs.org
