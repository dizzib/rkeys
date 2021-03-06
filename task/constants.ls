Assert = require \assert
Shell  = require \shelljs/global

const DIRNAME =
  BUILD: \_build
  SITE : \site
  TASK : \task
  TEST : \test

root = pwd!

dir =
  BUILD: "#root/#{DIRNAME.BUILD}"
  build:
    SITE: "#root/#{DIRNAME.BUILD}/#{DIRNAME.SITE}"
    TASK: "#root/#{DIRNAME.BUILD}/#{DIRNAME.TASK}"
    TEST: "#root/#{DIRNAME.BUILD}/#{DIRNAME.TEST}"
  ROOT : root
  SITE : "#root/#{DIRNAME.SITE}"
  TASK : "#root/#{DIRNAME.TASK}"
  TEST : "#root/#{DIRNAME.TEST}"

module.exports =
  APPNAME: \rkeys
  dirname: DIRNAME
  dir    : dir

Assert test \-e dir.SITE
Assert test \-e dir.TASK
Assert test \-e dir.TEST
