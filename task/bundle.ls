Browsify = require \browserify
Brfs     = require \brfs
Cacheify = require \cacheify # reduces bundle time from 1.5 to 0.3 secs!
Exposify = require \exposify
Fs       = require \fs
LevelUp  = require \levelup
_        = require \lodash
Memdown  = require \memdown
Shell    = require \shelljs/global
W4       = require \wait.for .for
Dir      = require \./constants .dir
Dirname  = require \./constants .dirname
G        = require \./growl

cache = brfs:(LevelUp Memdown), exposify:LevelUp Memdown
Exposify.config = underscore:\_

module.exports = me =
  app: (opath) ->
    bundle \app.js, ->
      # Cacheify has no concept of dependencies so we must ensure an update to a brfs'd
      # file invalidates its parent js. Quick and dirty method is to clear the whole cache!
      if /\.(html|css)$/.test opath # file types which can be brfs'd
        log "cache invalidated by #opath"
        cache.brfs = LevelUp Memdown
        cache.exposify = LevelUp Memdown
      b = Browsify \./boot.js
        ..transform Cacheify Exposify, cache.exposify
        ..transform Cacheify Brfs, cache.brfs
      b

## helpers

function bundle path, fn-setup
  pushd "#{Dir.build.SITE}/app"
  try
    W4 (cb) ->
      t0 = process.hrtime!
      b = fn-setup!
      out = Fs.createWriteStream path
        ..on \finish, ->
          t = process.hrtime t0
          size = Math.floor out.bytesWritten / 1024
          G.say "Bundled #path (#{size}k) in #{t.0}.#{t.1}s"
          G.alert "#path is too large!" if size > 100k
          cb!
      b.bundle detectGlobals:false, insertGlobals:false
        ..on \error, ->
          G.alert "Bundle error: #{it.message}"
          cb!
        ..pipe out
  finally
    popd!
