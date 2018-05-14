(
SynthDef.new(\sine, {| freq=220, atk=0.005, rel=0.3, amp=0.4, pan = 0|
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.new([0,1,0], [atk,rel], [1,-1]),doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	Out.ar(0, sig);
}).add;
)

Synth(\sine);



(
Pdef(
	\sinepat,
    Pbind(
		\instrument, \sine,
		\dur, Pseq([1, 0.8, 1], inf),
		\midinote, Pseq([40, 59, 57, 42], inf),
		\harmonics, Pexprand([1, 80], inf),
		\atk, Pwhite(0.8, 0.6, inf),
		\rel, Pwhite(0.7, 1, inf),
		\amp, Pexprand( 0.2, 0.3, inf),
	);
).play;
)


(
SynthDef.new(\wave, { |freq = 440, atk = 1, rel = 1, amp = 1, pan = 0|
	var sig, env;
	sig = Dust.ar(10);
	env = EnvGen.kr(Env.new([0, 1, 0], [atk, rel], [1, -1]), doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env * 2;
	sig = FreeVerb.ar(sig, 0.8, 0.6, 0.4, 2);
	Out.ar(0, sig);
}).add;
)

Synth(\wave);

(
Pdef(
	\patt,
    Pbind(
		\instrument, \wave,
		\dur, Pseq([0.4, 0.3, 0.4], inf),
		\midinote, Pseq([66, 70, 73], inf),
		\atk, Pwhite(0.2, 0.5, inf),
		\rel, Pwhite(0.2, 0.3, inf),
		\amp, Pexprand( 0.8, 1, inf),
	);
).play;
)

(
SynthDef.new(\klang, {|amp = 0.2, pan = 0
	freqs = #[55, 130, 174, 740],
	amps = #[0.35, 0.23, 0.12, 0.05],
	phases = #[pi, pi, pi, pi, pi]|
	var sig, env;
	sig = Klang.ar(`[freqs, amps, phases]);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(0, sig);

}).play;
)

(
4.do{
	Synth(
		\klang
	);
};
)



(
Pdef(
	\patt,
    Pbind(
		\instrument, \klang,
		\dur, Pseq([0.6, 0.6, 0.4], 10),
		\midinote, Pseq([66, 70, 73], 10),
		\atk, Pwhite(0.2, 0.5, 10),
		\rel, Pwhite(0.2, 0.3,  10),
		// \amp, Pexprand( 0.9, 1, inf),*/
	);
).play
)

(
SynthDef(\saw, {|freq = 500, pan = 0, amp = 0.5|
	var sig, env;
	sig = Saw.ar(freq);
	sig = BPF.ar(sig, 1200, 0.3);
	sig = sig * amp;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(0, sig);
}).add;
)

(
4.do {
	Synth(
		\saw,
		[
			\freq, exprand(100, 200),
		]
	);
};
)

(
{
loop({
    play({
			Pan2.ar(Klang.ar(`[ [540, 620, 700], [0.3, 0.3, 0.3], [pi/2, pi/2, pi/2]], 0.4, 0.1) * 0.2)

    });
    0.8.wait;
})
}.fork;
)


(
SynthDef.new(\multi, {
	var sig, amp, env;
	env = EnvGen.kr(
		Env.new([0.1, 0], [10, 10], [1, -1]),
		doneAction:2);
	amp = SinOsc.kr({ExpRand(0.2, 12)}!8).range(0, 1);
	sig = SinOsc.ar({ExpRand(50, 1200)}!8);  //multichanel
	sig = sig * amp;
	sig = Splay.ar(sig) * 0.5;
	Out.ar(0, sig);
}).add;
)
x = Synth.new(\multi);