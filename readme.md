## rkeys

A platform for creating tablet/HTML5 apps to send keystrokes to remote [X11]:

- [define keypads](./site/app) with a bit of [jade] and [stylus]
- [define chords and sequences](./site/app/example.yaml) with delays and auto-repeat
- use the built-in [mixins](./site/ui/mixin) and [templates](./site/ui/template) to minimise your code
- enhance with [LiveScript] and [Font Awesome][fa] icons
- context sensitivity - show/hide elements matching the active window title
- simulate mouse buttons and run shell commands

## install

With [node.js] installed on the target [X11] box:

    $ npm install -g rkeys      # might need to prefix with sudo

## run examples

    $ rkeys

then navigate your tablet to `http://your-rkeys-server:7000/example`
(see [example code](./site/app)):

![example screenshot](http://dizzib.github.io/rkeys/example.png)

Also see [rkeys-apps](https://github.com/dizzib/rkeys-apps) for more.

## tutorial

An rkeys app is a directory containing at least one jade file.

    $ mkdir foo

Create file `./foo/bar.jade` with the following content:

    extend /template/keys

    block layout
      +key('a')

Host the app by passing the app's directory on the command line:

    $ rkeys foo

then navigate your tablet to `http://your-rkeys-server:7000/bar`:

![tutorial screenshot](http://dizzib.github.io/rkeys/tutorial.png)

## options

    $ rkeys --help
    Usage: rkeys [options] <directory ...>

    Options:

      -h, --help             output usage information
      -V, --version          output the version number
      -g, --gen-ssl-cert     generate a self-signed ssl certificate
      -p, --port [port]      listening port (default:7000)

Host multiple apps simutaneously by specifying their directories:

    $ rkeys ./app1 ./app2 ~/app3

## hosting over https

In a new empty directory either [create the key.pem and cert.pem manually](http://stackoverflow.com/questions/10175812/how-to-create-a-self-signed-certificate-with-openssl?rq=1)
or do the following:

    $ rkeys -g      # generate using openssl. Follow the prompts.

Include this directory on the `rkeys` command line to host your apps over
https on port + 1 (default 7001):

    https://your-rkeys-server:7001/app

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
