# assign some basic sounds
$ '.key:not(.latching)' .on \touchstart Sound.hiss
$ \.key.latching
  ..on \touchstart Sound.jump
  ..on \touchend   Sound.land
