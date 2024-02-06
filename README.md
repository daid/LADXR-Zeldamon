= What?

You have reached it. This is the source code for LADXR-ZeldaMon.

The goal of this is to turn Links Awakening DX into a pokemon style battler. With capturing mons, training them, leveling up, different moves, etc...

= How?

How to use this? Right now, this is based on the [Links awakening DX Randomizer](https://github.com/daid/LADXR/), you will need to get that source code as well to use this.
Or use the [online generator](https://ladxr.daid.eu/latest/mon/)

For the source version, you will need to run:
```
git clone https://github.com/daid/LADXR.git
git clone https://github.com/daid/LADXR-ZeldaMon.git
cd LADXR
python3 main.py input.gbc --output LADXR_ZeldaMon.gbc --pymod ../LADXR-ZeldaMon/zeldamon.py --plan ../LADXR-ZeldaMon/plan.txt
```

= Status

* Initial mon is given by the kids throwing the ball at the town entrance
* Touching enemies will trigger wild battles
* Bosses trigger boss battles
* Basic attacks sort of work, but damage calculations seem to be "off"
* 100+ different monsters have stat tables and graphics

= Todo

There is SO much to do to make this "better". Here is a short list of ideas:

* Improve/fix basic damage calculations
* Add basic move effects for stats up/down
* Improve graphics of mons (bonus: support graphics with more then 4 colors)
* Add miniboss battles
* Allow capture/optaining boss mons in some way
* Mon storage system
* More items
* Better enemy AI (it always picks the first move from the list)
* Apply the LADXR single save slot patch

= Inner workings

This mod works by patching into various bits of zelda to call into custom code. We double the size of the rom, so there is a ton of space to work with, ROM space generally is not an issue.

LADX uses very little of the available SRAM in the cart, so we gladly make use of that:
* To help with ROM banking, the mod stores a bunch of code in SRAM so that can be called from any bank.
* To store runtime and mon data, we just store everything in SRAM