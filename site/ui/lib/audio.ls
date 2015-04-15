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
  noise:
    brown: create-noise type:\brown
    pink : create-noise type:\pink
    white: create-noise type:\white

function create-beep {freq=1000hz, dur=0.025s, toFreq, type} = {}
  oc = new OfflineAudioContext MONO, SAMPLERATE * dur, SAMPLERATE
  osc = oc.createOscillator!
    ..frequency.value = freq
    ..frequency.setTargetAtTime toFreq, 0, dur if toFreq?
    ..type = type if type?
    ..start!
    ..stop dur
  render-cache-offline oc, osc

function create-noise {dur=0.025s, type=\white} = {}
  const GENS =
    brown: Noise.create-brown-noise
    pink : Noise.create-pink-noise
    white: Noise.create-white-noise
  size = SAMPLERATE * dur
  oc = new OfflineAudioContext MONO, size, SAMPLERATE
  b = oc.createBuffer MONO, size, SAMPLERATE
  samples = GENS[type] size
  arr = b.getChannelData 0
  for i to size - 1 then arr[i] = samples[i]
  noise = oc.createBufferSource!
    ..buffer = b
    ..start!
    ..stop dur
  render-cache-offline oc, noise

function create-cache
  # For some reason web-api audio has unacceptable latency
  # even when buffered so output using html5 audio.
  # May need to revisit at some point.
  audio = []
  p = 0
  init: (samples) ->
    for i from 0 to CACHE-SIZE - 1
      audio[i] = new Audio WavEncoder.encode samples
  play: ->
    audio[p++ % CACHE-SIZE]?play!

function render-cache-offline oc, generator
  cache = create-cache!
  generator.connect oc.destination
  oc.oncomplete = -> cache.init it.renderedBuffer.getChannelData 0
  oc.startRendering!
  cache.play
