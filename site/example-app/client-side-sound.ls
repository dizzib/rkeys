# client-side sounds
Sound = require \lib/audio

$ \#i .on \touchstart Sound.beep
$ \#j .on \touchstart Sound.blip
$ \#k .on \touchstart Sound.blop
$ \#l .on \touchstart Sound.rise .on \touchend Sound.drop
$ \#m .on \touchstart Sound.noise.brown
$ \#n .on \touchstart Sound.noise.pink
$ \#o .on \touchstart Sound.noise.white

# uncomment the following line for latch/unlatch sounds
#$ \.key.latchable .on \latch Sound.rise .on \unlatch Sound.drop
