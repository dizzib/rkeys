Assert = require \assert
Shell  = require \shelljs/global
W4     = require \wait.for .for
Args   = require \./args
Dir    = require \./constants .dir

module.exports =
  prepare: ->
    if test \-e pjson = "#{Dir.BUILD}/package.json"
      cp \-f pjson, Dir.ROOT
      cp \-f pjson, Dir.build.SITE
    cp \-f "#{Dir.ROOT}/readme.md" Dir.build.SITE

  publish-local: ->
    pushd Dir.build.SITE
    try
      port = Args.reggie-server-port
      W4 exec, "reggie -u http://localhost:#port publish" silent:false
    finally
      popd!

  publish-public: ->
    pushd Dir.build.SITE
    try
      W4 exec, 'npm publish' silent:false
    finally
      popd!
