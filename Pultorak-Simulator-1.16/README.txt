Mods to V1.16 for USB DSKY control.  

There are a bunch of changes to this branch. It is hard to tell exactly what changed but besides getting this to compile on Microsoft Visual Studio Community 2015 (Version 14.0.25431.01 Update 3) there are really only a bunch of changes to add a serial I/O.  
Because it was a complete hack just to see a real DSKY display from John Pultorak’s Block1 simulator, I hardcoded the COM4 which is where the original USB port ended up on my machine from Teensey3.2 Hardware. This is almost guaranteed must be changed to work on your hardware, but once you get it to compile it should be easy, right?  Also, this runs disappointingly slooooow. You must push keys deliberately.  And all the usual start up   for V1,16 must be undertaken, <F1> etc.  I added some of the indicators to help show the states.  But it does work!   I may need to backport to better see the DIFF changes. Here is the history until I stopped development:

VERSIONS :
 *   2.0 -  AGC4 V2.0 Required Revisions:
 *	2.0 12/26/16 "Port" to Microsoft Visual C++ 2015   S.BOTTS [SB]
 *	2.0.1 added precompiled header "stdafx.h" and namspace std for console output
 *	2.0.2 changed some string methods to _s mostly to suppress warnings.
 *   2.1 Change Keys to match mini-DSKY hardware (AGCmain.cpp)
 *  2.2 Change update rate from 2 sec.(AGCmain.cpp)
 *  2.3 Add Serial output for DSKY Display (MON.cpp)
 *  2.4 Added Some Start up indicators:
 *		UPLINK - Load AGC Files extinguished after (l)oading HEX files
 *		STBY - FCLCK = 1 ( fast clock) will extinguish after F4
 *		RESTART - Turns on when connected, turns off after (R)un
 *  NOTES:
 *	(1) set tabs to 4 spaces to keep columns formatted correctly.
 *	(2) AGC4 V2.0 on uDSKY hardware REQUIRED TO RUN
 *	(3) Some REVs in AGCmain.CPP needed for MINI DSKY HARDWARE
 *      	(4) Currently only runs on COM4
 *      	(5) Needs DSKY.h for reference
 * TODO: 
 * FIX THIS WARNING: in \\\\visual studio 2015\projects\agc4\out.h(68): 
 * warning C4094: untagged 'class' declared no symbols
 *
 *  PORTABILITY:
 *  Compiled with Microsoft Visual C++ 6.0 standard edition. Should be fairly
 *  portable, except for some Microsoft-specific I/O and timer calls in this file.
 

