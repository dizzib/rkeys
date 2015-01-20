Assert = require \assert
Shell  = require \shelljs/global

const DIRNAME =
  BUILD: \_build
  SITE : \site
  TASK : \task

root = pwd!

dir =
  BUILD: "#root/#{DIRNAME.BUILD}"
  build:
    SITE : "#root/#{DIRNAME.BUILD}/#{DIRNAME.SITE}"
    TASK : "#root/#{DIRNAME.BUILD}/#{DIRNAME.TASK}"
  ROOT : root
  SITE : "#root/#{DIRNAME.SITE}"
  TASK : "#root/#{DIRNAME.TASK}"

module.exports =
  dirname: DIRNAME
  dir    : dir

Assert test \-e dir.SITE
Assert test \-e dir.TASK
