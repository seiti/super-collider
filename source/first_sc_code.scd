# Server.default.boot;
# Server.default is the same as simply 's'
# s.boot;
# s.quit;

# To free all functions/sounds or ctrl-.
s.freeAll


# s.scope shows an oscilloscope display

x = {[
	SinOsc.ar(440, 0, 0.2),
	SinOsc.ar(442, 0, 0.2)
]}.play;

x.free


(
{
	var ampOsc;
	ampOsc = SinOsc.kr(0.5, 1.5pi, 0.5, 0.5);
	SinOsc.ar(440, 0, ampOsc);
}.play
)


(
{
	var ampOsc;
	ampOsc = SinOsc.kr(0.5, 1.5pi, 0.5, 0.5);
	[
	SinOsc.ar(440, 0, ampOsc),
	SinOsc.ar(442, 0, ampOsc)
]
}.play
)



{ Pan2.ar(PinkNoise.ar(0.2), SinOsc.kr(0.5)) }.play;


{ PinkNoise.ar(0.2) + SinOsc.ar(440, 0, 0.2) + Saw.ar(660, 0.2) }.scope;