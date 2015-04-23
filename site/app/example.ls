# assign some basic sounds
Sound = require \lib/audio

$ '.key:not(.latchable)' .on \touchstart Sound.noise.brown
$ \.key.latchable
  ..on \latch   Sound.rise
  ..on \unlatch Sound.drop
