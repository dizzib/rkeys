# assign some basic sounds
$ '.key:not(.latchable)' .on \touchstart Sound.noise.brown
$ \.key.latchable
  ..on \latch   Sound.rise
  ..on \unlatch Sound.drop
