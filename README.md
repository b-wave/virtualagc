This branch has been merged back into master, and is now obsolete, though the information below is probably still correct.

# virtualagc
Virtual Apollo Guidance Computer (AGC) software

The 'block1' branch of the virtualagc repo is used for development of Block 1 AGC and DSKY simulators, with the idea of being able to use them to simulate Block 1 AGC programs like Solarium055 or Corona.  When the programs in this directory are mature, this branch may or may not be merged into the master branch.

At present, there are three separate AGC simulators present or under development, along with one DSKY simulator.

- Pultorak-Simulator-1.16/ contains John Pultorak's Block 1 AGC simulator, based on simulation of "control pulses" (microcode), as opposed to basic instructions (assembly language).  This is John's original Visual C++ program, version 1.16, as-is.  Earlier versions of the program (1.15 down to 1.01) are availalable at [ibiblio.org/apollo](http://www.ibiblio.org/apollo/Pultorak.html), but not in this repository.  The program has three known defects that prevent it from being able to run Solarium:  It has only half the memory banks required; the interrupt-vector table (including the main program entry point) is at the wrong location in memory; timers increment 1000 times/second rather than 100 times/second.
- yaAGC-Block1-Pultorak/ contains a port of Pultorak-Simulator-1.16 to gcc, and fixes the problems mentioned above.  It also has a variety of cosmetic changes, additions to the command-line switches, and so forth.  It is capable of running Solarium, as far as I can tell, but uses it's own internal textual DSKY interface, as opposed to our DSKY simulation.
- yaAGCb1/ is an independently-written Block 1 AGC simulator by Ron Burkey, but closely cross-checked against yaAGC-Block1-Pultorak behaviorally, with the goal of matching the two on a cycle-by-cycle, register-by-register basis.  It is intended to interface to our DSKY simulation, but it is a work in progress and does not presently do so.
- yaDSKYb1/ will be a Block 1 DSKY simulation.  There are two separate front-ends, to correspond to the fact that the Block 1 DSKYs for the control panel and nav bay were substantially different externally, though using the same underlying engine.  At present, this program exists only as graphics files that show what the end result will look like.
