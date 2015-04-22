Fs   = require \fs
Path = require \path
_    = require \lodash
Yaml = require \js-yaml
Sh   = require \shelljs/global
Args = require \../args

cache = fpaths:[]

transform-command = (fn, cmd) -->
  if _.isArray cmd then _.map cmd, fn else fn cmd

module.exports = me =
  apply-aliases: transform-command apply-aliases
  get-command  : (id) -> cache.commands[id]
  get-sidechain: -> cache.sidechain

load-all!

function apply-aliases
  _.reduce cache.aliases, ((s, v, k) -> s.replace k, v), it

function build-cache cfgs
  cache.aliases   = as = {}
  cache.commands  = cs = {}
  cache.sidechain = sc = [] # sidechain order matters

  for cfg in cfgs # extract aliases first
    for id, c of cfg when /^alias /.test c
      as[id] = c.slice 6
      delete cfg[id]
  for cfg in cfgs
    for id, c of cfg
      cmd = me.apply-aliases c
      if is-sidechain = /^\/.*\/$/.test id
        _.remove sc, -> it.id is id
        sc.push id:id, cmd:cmd, rx:create-sidechain-rx id
      else cs[id] = cmd
  for o in sc then log "sidechain #{o.rx}: #{o.cmd}"
  #log cache

  function create-sidechain-rx id
    new RegExp id[1 to -2] * '' # strip surrounding /s

function load-all
  for p in cache.fpaths then Fs.unwatchFile p
  # order matters: later yaml overrides earlier, so load the
  # rkeys yaml first so it can be overridden by apps.
  dirs  = [ __dirname ] ++ Args.dirs
  cache.fpaths = _.flatten [ls "#d/*.yaml" for d in dirs]
  build-cache [ load-file p for p in cache.fpaths ]
  for p in cache.fpaths then Fs.watchFile p, load-all

function load-file path
  log "load commands from #path"
  return log "MISSING #path" unless test \-e path
  cfg = Yaml.safeLoad Fs.readFileSync path
  dir = Path.dirname path

  # apply includes
  for k, v of cfg when k is \include
    log "include #v"
    delete cfg.include
    for p-inc in paths = (v - \,) / ' '
      p = Path.resolve dir, p-inc
      ps = if test \-d p then ls "#p/*.yaml" else [ p ]
      for p in ps then cfg = _.extend cfg, load-file p

  # resolve relative paths
  _.mapValues cfg, transform-command ->
    for s, i in arr = it / ' ' when /^\.{1,2}\//.test s
      arr[i] = Path.resolve dir, s
    arr * ' '
