# audio.ls
Noise = require \./noise

const CACHE-SIZE = 3buffers
const MONO       = 1channel
const SAMPLERATE = 44100hz

module.exports =
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
  ctx <- render-cache-offline dur
  ctx.createOscillator!
    ..frequency.value = freq
    ..frequency.setTargetAtTime toFreq, 0, dur if toFreq?
    ..type = type if type?

function create-noise {dur=0.025s, type=\white} = {}
  const GENS =
    brown: Noise.create-brown-noise
    pink : Noise.create-pink-noise
    white: Noise.create-white-noise
  ctx, size <- render-cache-offline dur
  b = ctx.createBuffer MONO, size, SAMPLERATE
  samples = GENS[type] size
  data = b.getChannelData 0 # copyToChannel() not supported yet
  for i to size - 1 then data[i] = samples[i]
  ctx.createBufferSource!
    ..buffer = b

function create-cache
  # For some reason web-api audio has unacceptable latency
  # even when buffered so output using html5 audio.
  # May need to revisit at some point.
  audio = []
  p = 0
  init: (samples) ->
    data = WavEncoder.encode samples
    for i to CACHE-SIZE - 1 then audio[i] = new Audio data
  play: -> audio[p++ % CACHE-SIZE]?play!

function render-cache-offline dur, create-generator
  size = SAMPLERATE * dur
  c = new OfflineAudioContext MONO, size, SAMPLERATE
  generator = create-generator c, size
    ..connect c.destination
    ..start!
    ..stop dur
  cache = create-cache!
  c.oncomplete = -> cache.init it.renderedBuffer.getChannelData 0
  c.startRendering!
  cache.play
