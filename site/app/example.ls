# assign some basic sounds
$ '.key:not(.latchable)' .on \touchstart Sound.blop
$ \.key.latchable
  ..on \latch   Sound.rise
  ..on \unlatch Sound.fall
