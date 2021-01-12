#Server.default.boot;
{ [SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)] }.play;

f = { arg a: "Function evaluated".postln; };
f.value;

s.boot;


x = { SinOsc.ar(440, 0, 0.2) }.play;
x.free;

s.boot

3.cubed

