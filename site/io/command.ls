Fs   = require \fs
Path = require \path
_    = require \lodash
Yaml = require \js-yaml
Sh   = require \shelljs/global
U    = require \util
Args = require \../args

cache = fpaths:[]

transform-command = (fn, cmd) -->
  if _.isArray cmd then _.map cmd, fn else fn cmd

module.exports = me =
  apply-aliases : transform-command apply-aliases
  get-command   : (id) -> cache.commands[id]
  get-sidechains: -> cache.sidechains

load-all!

function apply-aliases
  _.reduce cache.aliases, ((s, v, k) -> s.replace k, v), it

function build-cache cfgs
  cache.aliases    = as = {}
  cache.commands   = cs = {}
  cache.sidechains = ss = {}

  for cfg in cfgs # extract aliases first
    for id, c of cfg when /^alias /.test c
      as[id] = c.slice 6
      delete cfg[id]
  for cfg in cfgs
    for id, val of cfg
      if is-sidechain = /^\/.*\/$/.test id
        chain = [] # command order matters in a sidechain
        unless _.isObject val then throw new Error do
          "Invalid sidechain: expecting a series of key value pairs at #id: #val"
        for cid, cmd of val
          unless /^\/.*\/$/.test cid then throw new Error """
            Invalid sidechain key: #cid should be a regular expression surrounded
            by / in #val"""
          _.remove chain, -> it.id is cid
          chain.push id:cid, cmd:(me.apply-aliases cmd), rx:get-rx-by-id cid
        ss[id] = chain:chain, rx:get-rx-by-id id
      else cs[id] = me.apply-aliases val
  log2 U.inspect cache, depth:null

  function get-rx-by-id id
    new RegExp id[1 to -2] * '' # strip surrounding /s

function load-all
  # Note: Fs.watch doesn't seem to work across a network
  for p in cache.fpaths then Fs.unwatchFile p
  # order matters: later yaml overrides earlier, so load the
  # rkeys yaml first so it can be overridden by apps.
  dirs  = [ __dirname ] ++ Args.dirs
  cache.fpaths = _.flatten [ls ["#d/*.yaml" "#d/*.yml"] for d in dirs]
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
      ps = if test \-d p then ls ["#p/*.yaml" "#p/*.yml"] else [ p ]
      for p in ps then cfg = _.extend cfg, load-file p

  # resolve relative paths
  _.mapValues cfg, transform-command ->
    return it if _.isObject it
    for s, i in arr = it / ' ' when /^\.{1,2}\//.test s
      arr[i] = Path.resolve dir, s
    arr * ' '
