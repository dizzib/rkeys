# audio.ls

const CACHE-SIZE = 3buffers
const MONO       = 1channel
const SAMPLERATE = 44100hz

window.Sound =
  create-beep : create-beep
  create-noise: create-noise
  beep        : create-beep!
  blip        : create-beep type:\square freq:9000hz
  blop        : create-beep type:\square freq:100hz
  drop        : create-beep toFreq:0hz
  rise        : create-beep toFreq:2000hz
  noise       : create-noise!

function create-beep {freq=1000hz, dur=0.025s, toFreq, type} = {}
  oc = new OfflineAudioContext MONO, SAMPLERATE * dur, SAMPLERATE
  osc = oc.createOscillator!
    ..frequency.value = freq
    ..frequency.setTargetAtTime toFreq, 0, dur if toFreq?
    ..type = type if type?
    ..start!
    ..stop dur
  render-cache oc, osc

function create-noise {dur=0.025s} = {}
  samples = []
  for i from 0 to SAMPLERATE * dur then samples[i] = 2 * Math.random! - 1
  c = create-cache!
  c.init samples
  c.play

function create-cache
  audio = []
  p = 0
  init: (samples) ->
    for i from 0 to CACHE-SIZE - 1
      audio[i] = new Audio WavEncoder.encode samples
  play: ->
    audio[p++ % CACHE-SIZE]?play!

function render-cache oc, generator
  cache = create-cache!
  generator.connect oc.destination
  oc.oncomplete = -> cache.init it.renderedBuffer.getChannelData 0
  oc.startRendering!
  cache.play
