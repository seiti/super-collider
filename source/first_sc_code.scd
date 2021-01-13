# Server.default.boot;
# Server.default is the same as simply 's'
# s.boot;
# s.quit;

# To free all functions/sounds or ctrl-.
s.freeAll


# s.scope shows an oscilloscope display

({[
	SinOsc.ar(440, 0, 0.2),
	SinOsc.ar(442, 0, 0.2)
]}.play)



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


(
f = {
	PinkNoise.ar(0.2) +
	SinOsc.ar(440, 0, 0.2) +
	Saw.ar(660, 0.2)
};
{[f, Pan2.ar(f, -0.3)]}.scope)



// one channel
{ Mix.new([SinOsc.ar(440, 0, 0.2), Saw.ar(660, 0.2)]).postln }.play;

// combine two stereo arrays
(
{
    var a = [
		SinOsc.ar(440, 0, 0.2), Saw.ar(662, 0.2)];
    var b = [
		SinOsc.ar(442, 0, 0.2), Saw.ar(660, 0.2)];
    Mix([a, b]).postln;
}.play;
)


// Look at the post window for frequencies and indices
(
    var n = 8;
    {
        Mix.fill(n, { arg index;var freq;
            index.postln;
            freq = 440 + index;
            freq.postln;
            SinOsc.ar(freq , 0, 1 / n)
        })
    }.play;
)

{ PinkNoise.ar(0.2) + SinOsc.ar(440, 0, 0.2) + Saw.ar(660, 0.2) }.play


(
SynthDef.new("tutorial-SinOsc-stereo", { var outArray;
    outArray = [SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)];
    Out.ar(0, outArray)
}).play;
)



// execute first, by itself
SynthDef.new("tutorial-PinkNoise", { Out.ar(0, PinkNoise.ar(0.3)) }).add;

// then:
x = Synth.new("tutorial-PinkNoise");
y = Synth.new("tutorial-PinkNoise");
x.free; y.free;







### sequencing

(
SynthDef(\bass, { |out, freq = 440, gate = 1, amp = 0.5, slideTime = 0.17, ffreq = 1100, width = 0.15,
        detune = 1.005, preamp = 4|
    var sig, env;
    env = Env.adsr(0.01, 0.3, 0.4, 0.1);
    freq = Lag.kr(freq, slideTime);
    sig = Mix(VarSaw.ar([freq, freq * detune], 0, width, preamp)).distort * amp
        * EnvGen.kr(env, gate, doneAction: Done.freeSelf);
    sig = LPF.ar(sig, ffreq);
    Out.ar(out, sig ! 2)
}).add;

TempoClock.default.tempo = 132/60;

p = Pxrand([
    Pbind(
        \instrument, \bass,
        \midinote, 36,
        \dur, Pseq([0.75, 0.25, 0.25, 0.25, 0.5], 1),
        \legato, Pseq([0.9, 0.3, 0.3, 0.3, 0.3], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\bass,
        \midinote, Pseq([36, 48, 36], 1),
        \dur, Pseq([0.25, 0.25, 0.5], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\bass,
        \midinote, Pseq([36, 42, 41, 33], 1),
        \dur, Pseq([0.25, 0.25, 0.25, 0.75], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\bass,
        \midinote, Pseq([36, 39, 36, 42], 1),
        \dur, Pseq([0.25, 0.5, 0.25, 0.5], 1),
        \amp, 0.5, \detune, 1.005
    )
], inf).play(quant: 1);
)

// totally cheesy, but who could resist?
(
SynthDef(\kik, { |out, preamp = 1, amp = 1|
    var freq = EnvGen.kr(Env([400, 66], [0.08], -3)),
        sig = SinOsc.ar(freq, 0.5pi, preamp).distort * amp
            * EnvGen.kr(Env([0, 1, 0.8, 0], [0.01, 0.1, 0.2]), doneAction: Done.freeSelf);
    Out.ar(out, sig ! 2);
}).add;

// before you play:
// what do you anticipate '\delta, 1' will do?
k = Pbind(\instrument, \kik, \delta, 1, \preamp, 4.5, \amp, 0.32).play(quant: 1);
)


({
({RHPF.ar(OnePole.ar(BrownNoise.ar, 0.99), LPF.ar(BrownNoise.ar, 14)
* 400 + 500, 0.03, 0.003)}!2)
+ ({RHPF.ar(OnePole.ar(BrownNoise.ar, 0.99), LPF.ar(BrownNoise.ar, 20)
* 800 + 1000, 0.03, 0.005)}!2)
* 4
}.play)


// Simple synth definition using the Atari2600 UGen:
(
SynthDef(\atari2600, {|out= 0, gate= 1, tone0= 5,
tone1= 8, freq0= 10, freq1= 20, amp= 1, pan= 0|
var e, z;
e= EnvGen.kr(Env.asr(0.01, amp, 0.05), gate, doneAction:2);
z= Atari2600.ar(tone0, tone1, freq0, freq1, 15, 15);
Out.ar(out, Pan2.ar(z*e, pan));
}).store
)

 // And a pattern to play it:
(
Pbind(
\instrument, \atari2600,
\dur, Pseq([0.25, 0.25, 0.25, 0.45], inf),
\amp, 0.8,
\tone0, Pseq([Pseq([2, 5], 32), Pseq([3, 5], 32)], inf),
\tone1, 14,
\freq0, Pseq([Pbrown(28, 31, 1, 32),
Pbrown(23, 26, 3, 32)], inf),
\freq1, Pseq([Pn(10, 16), Pn(11, 16)], inf)
).play
)