# audio.ls

const CACHE-SIZE = 10buffers
const MONO       = 1channel
const SAMPLERATE = 44100hz

window.Sound =
  create-beep : create-beep
  create-noise: create-noise
  hiss        : create-noise!
  jump        : create-beep 2000hz, 0.025s, 4000hz
  land        : create-beep 3000hz, 0.025s, 1000hz

function create-beep freq = 1000hz, dur = 0.025s, toFreq = freq
  oc = new OfflineAudioContext MONO, SAMPLERATE * dur, SAMPLERATE
  osc = oc.createOscillator!
    ..frequency.value = freq
    ..frequency.setTargetAtTime toFreq, 0, dur
    ..start!
    ..stop dur
  render-cache oc, osc

function create-noise dur = 0.025s
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
