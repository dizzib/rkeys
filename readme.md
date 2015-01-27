## typey-pad


## install and run

    $ npm install typey-pad
    $ cd node_modules/typey-pad
    $ node server

## options

    $ node server --help
    Usage: server [options]

    Options:

      -h, --help             output usage information
      -V, --version          output the version number
      -p, --port [port]      listening port (default:7000)

## usage

Navigate to `http://server:7000` where `server` is
the node.js server running typey-pad.

## examples


## build and run locally

    $ git clone git@github.com:dizzib/typey-pad.git

    $ npm install -g livescript   # ensure livescript is installed globally
    $ ./task/bootstrap            # compile the task runner and install dependencies
    $ node dist/task/repl         # launch the task runner
    typey-pad > b.fc               # compile everything

    $ node _build/site/server       # run it!

## license

MIT

[express]: https://github.com/visionmedia/express
[LiveScript]: https://github.com/gkz/LiveScript
[node.js]: http://nodejs.org
