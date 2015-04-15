# noise.ls
# http://noisehack.com/generate-noise-web-audio-api/

window.Noise =
  create-brown-noise: (buffer-size) ->
    last = 0
    _.map (white-noise buffer-size), (white) ->
      last := out = (last + 0.02 * white) / 1.02
      out * 3.5 # (roughly) compensate for gain

  create-pink-noise: (buffer-size) ->
    b = [0] * 6
    _.map (white-noise buffer-size), (white) ->
      b.0 = 0.99886 * b.0 + white * 0.0555179
      b.1 = 0.99332 * b.1 + white * 0.0750759
      b.2 = 0.96900 * b.2 + white * 0.1538520
      b.3 = 0.86650 * b.3 + white * 0.3104856
      b.4 = 0.55000 * b.4 + white * 0.5329522
      b.5 = -0.7616 * b.5 - white * 0.0168980
      out = _.reduce b, (sum, n) -> sum + n
      b.6 = white * 0.115926
      out += white * 0.5362
      out * 0.11 # (roughly) compensate for gain

  create-white-noise: (buffer-size) ->
    _.map (white-noise buffer-size), -> it * 0.2 # reduce gain

function white-noise buffer-size
  [ 2 * Math.random! - 1 for i to buffer-size - 1 ]
