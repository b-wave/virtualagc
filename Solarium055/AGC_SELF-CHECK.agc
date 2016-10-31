### FILE="Main.annotation"
# Copyright:	Public domain.
# Filename:	AGC_SELF-CHECK.agc
# Purpose:	Part of the source code for Solarium build 55. This
#		is for the Command Module's (CM) Apollo Guidance
#		Computer (AGC), for Apollo 6.
# Assembler:	yaYUL --block1
# Contact:	Jim Lawton <jim DOT lawton AT gmail DOT com>
# Website:	www.ibiblio.org/apollo/index.html
# Page Scans:	www.ibiblio.org/apollo/ScansForConversion/Solarium055/
# Mod history:	2009-10-03 JL	Created.
#		2016-08-19 RSB	Typos.
#		2016-08-23 RSB	More of the same.

## Page 265

		SETLOC	22000

# NEXT THREE CONSTANTS ARE USED IN RUPTCHK SUBROUTINE
OVCON		OCTAL	37767
TM1WAIT		OCTAL	00320
ZRUPTCON	ADRES	TSKADRS		# MUST BE ADDRESS OF TSKADRS

# NEXT SIX CONSTANTS ARE USED IN ERASCHK, CNTRCHK, AND CYCLSHF SUBROUTINES
CONCNTR1	EQUALS	BIT5		# 00020
CONERAS1	OCTAL	00060
CONERAS2	OCTAL	01774
CONC+S1		OCTAL	25252
CONC+S2		EQUALS	CSQ		# 40001

# NEXT 3 CONSTANTS ARE USED IN SHOWSUM ROUTINE
SUMADRS		ADRES	SKEEP1		# SKEEP1 HOLDS SUM OF BANK
VNCON		OCTAL	00501		# DISPLAY CONTENTS OF THREE ADDRESSES
SCADR		CADR	SDISPLAY
# THE FOLLOWING CONSTANTS ARE USED THROUGHOUT SELF-CHECK
SCON0		EQUALS	ZERO		# +0
SCON1		EQUALS	BIT1		# +1
SCON2		EQUALS	BIT2		# +2
SCON4		EQUALS	BIT3		# +4
SCON64		EQUALS	BIT7		# 00100
SCON1/4		EQUALS	BIT13		# 10000
SCON1/2		EQUALS	BIT14		# 20000
SCON+MAX	EQUALS	POSMAX		# 37777
SCON-2		EQUALS	MINUS2		# 77775
SCON-1		EQUALS	MINUS1		# 77776
SCONMAX		EQUALS	NEG0		# 77777

 -2		XCH	QADRS		# ENTRY HERE FROM -ZEROCHK AND -ONECHK
		TC	+2

ERRORS		XCH	Q		# FAILURE DETECTED - ALARM.
		TS	SFAIL		# SAVE CALLING Q FOR POSSIBLE FAILURE LOC.
		TC	ALARM
		OCT	01102
		XCH	ERCOUNT		# ADD +1 TO ERCOUNT REGISTER EVERY TIME
		AD	SCON1		# THERE IS AN ERROR IN SELF-CHECK
		XCH	ERCOUNT
		TC	SMODECHK	# START    SELF-CHECK AGAIN
		
-ZEROCHK	XCH	Q
		TS	QADRS		# HOLDS ADDRESS THAT WAS IN Q REGISTER
		XCH	Q
		CCS	A
		TC	ERRORS -2
		TC	ERRORS -2
		TC	ERRORS -2
## Page 266
		TC	Q



		CS	A
-ONECHK		XCH	Q
		TS	QADRS		# HOLDS ADDRESS THAT WAS IN Q REGISTER
		XCH	Q
		CCS	A
		TC	ERRORS -2
		TC	ERRORS -2
		CCS	A
		TC	ERRORS -2
		TC	Q


# CHECKS MOST CCS PULSES
CCSCHK		RELINT			# COMES HERE FROM INHIBIT LOOP AT SMODECHK
		CS	SCON2		# -2
		CCS	A		# C(A) = -2
		TC	ERRORS
		TC	ERRORS
		TC	+2
		TC	ERRORS
		CCS	A		# C(A) = +1, RESULT OF CCS -NUMBER
		TC	+4
		TC	ERRORS
		TC	ERRORS
		TC	ERRORS
		CCS	A		# C(A) = +0, RESULT OF CCS + NUMBER
		TC	ERRORS
		TC	+3
		TC	ERRORS
		TC	ERRORS
		CS	A
		CCS	A		# C(A) = -0, RESULT OF CCS +0
		TC	ERRORS
		TC	ERRORS
		TC	ERRORS
		CCS	A		# RESULT OF CCS -0
		TC	ERRORS
		TC	+3
		TC	ERRORS
		TC	ERRORS
# SPECIFICALLY CHECKS RSC PULSE OF TC INSTRUCTION (ALSO MOST OF TC
# PULSES)
		TC	+2
		TC	+2		# NEXT SUBROUTINE
		TC	Q
## Page 267

# CHECKS WP, GP, TP - WP2, RP2 - RG, WP, OF CCS1
# CHECKS RB, WG PULSES (READ BACK INTO ERASABLE)
PTY+ERAS	CAF	5777		# 47777
		TS	SKEEP1
		MASK	SKEEP1
		XCH	SKEEP1
		AD	SKEEP1
		INDEX	5777
		4	SKEEP1		# MP SKEEP1
		INDEX	5777
		5	SKEEP1		# DV SKEEP1
		CS	SKEEP1
		TS	SKEEP2		# 30000
		INDEX	SKEEP1		# TROUBLE IF C(SKEEP1) NOT 47777
		6	SKEEP2		# SU SKEEP2, C(A) = -0
		TS	SKEEP2		# -0
		CCS	SKEEP2
		TC	ERRORS
		TC	ERRORS
		TC	ERRORS
		CCS	SKEEP2
		TC	ERRORS
		TC	ERRORS
		TC	ERRORS		
# START ERASABLE INSTRUCTION CHECK
		CAF	EINST1
		TS	SKEEP1
		CAF	EINST2
		TS	SKEEP2
		CAF	EINST3
		TS	SKEEP3
		CAF	EINST4
		TS	SKEEP4
		CAF	EINST5
		TS	SKEEP5
		CAF	EINST6
		TS	SKEEP6
		CAF	SCON1/2
		TC	SKEEP1
EINST1		INDEX	5777
EINST2		4	SCON2		# MP, C(A) = +1, THEN +0
EINST3		AD	A		# CHECKS ST2 PARITY
EINST4		CCS	A
EINST5		TC	SKEEP1
EINST6		TC	+1		# NEXT SUBROUTINE



# CHECKS RSC, WSC PULSES
# NO WSC PULSE IN MASK INSTRUCTION
SCCHK		CAF	SCON64		# 00100
## Page 268
		XCH	LP		# 00040
		XCH	LP
		TS	LP		# 00020
		AD	LP		# 00010
		INDEX	LP		# 00004
		2	5767		# INDEX 5777
		6	0003		# SU LP, 00002
# NEXT 4 INSTRUCTIONS CHECK RSC PULSE IN MASK INSTRUCTION
		CS	LP		# C(A) = -2, C(LP) = +1
		MASK	LP		# C(A) = +1, C(LP) = +1
		CS	A
		TC	-ONECHK
		CCS	LP
		TC	+4
		TC	ERRORS
		TC	ERRORS
		TC	ERRORS
		CCS	LP
		TC	ERRORS
		TC	ERRORS
		TC	+2
		TC	ERRORS
		CCS	LP
		TC	ERRORS
		TC	+3		# NEXT SUBROUTINE
		TC	ERRORS
		TC	ERRORS
# CHECKS MOST OF MP PULSES
MPCHK		CAF	SCON4
		TS	LP
MP++		CAF	SCON+MAX
		INDEX	5777
		4	LP		# C(A) = +1, CHECKS RSC PULSE
		AD	LP		# C(LP) = +37776
		TS	SKEEP1		# 37777
MP+-		CAF	SCON+MAX
		INDEX	5777
		4	SCON-2
		AD	LP		# C(LP) = -37776
		AD	SKEEP1
		TC	-ZEROCHK
MP--		CS	SCON+MAX
		INDEX	5777
		4	SCON-2		# C(A) = +1
		AD	LP		# C(LP) = +37776
		TS	SKEEP1		# 37777
MP-+		CS	SCON+MAX
		INDEX	5777
		4	SCON2		# C(A) = -1
		AD	LP		# C(LP) = -37776
## Page 269
		AD	SKEEP1
		TC	-ZEROCHK


# CHECKS MOST OF SU PULSES
SUCHK		CAF	SCON+MAX
		INDEX	5777
		6	SCONSU		# SU 37776, C(A) = +1
		TC	-ONECHK -1

# CHECKS MOST OF DV PULSES (ALL EXCEPT WP, GP, TP)
# DIVIDE USES ST2
# ++ AND --, C(A) = 25252, C(Q) = 67777, C(LP) = +1
# +- AND -+ , C(A) = 52525, C(Q) = 67777, C(LP) = 40000 AND 40001
DVCHK		CAF	SCON3/8
		TS	Q
DV++		CAF	SCON1/4
		INDEX	5777
		5	Q		# C(A) = 25252, CHECKS RSC PULSE
		TS	SKEEP1
		XCH	LP
		TS	SKEEP2
DV+-		CS	Q		# +1/4
		INDEX	5777
		5	SCON-3/8	# C(A) = 52525
		AD	SKEEP1		# C(A) = -0
		TS	SKEEP5		# SHOULD BE -0
		XCH	LP
		TS	SKEEP3
DV--		XCH	Q		# -1/4
		INDEX	5777
		5	SCON-3/8	# C(A) = 25252
		TS	SKEEP1
		XCH	LP
		TS	SKEEP4
DV-+		XCH	Q		# -1/4
		INDEX	5777
		5	SCON3/8
		AD	SKEEP1		# C(A) = -0
		TS	SKEEP1
		CS	LP		# C(A) = 37776
		AD	SKEEP1		# C(A) = 37776
		AD	SKEEP2		# C(A) = 37777
		AD	SKEEP3		# C(A) = -0
		AD	SKEEP4		# C(A) = +1
		AD	SKEEP5		# C(A) = +1
		TC	-ONECHK -1


# CHECKS MOST TS PULSES
## Page 270
# CHECKS ALL OF PINC AND MINC PULSES EXCEPT WOVR
TS+-CHK		CAF	SCON1
		TS	OVCTR
		AD	SCON+MAX	# C(A) = + WITH OVERFLOW
		TS	SKEEP1
		TC	ERRORS
		AD	SKEEP1		# C(A) = +1
		AD	OVCTR		# C(A) = +3
		TS	OVCTR
		CS	A		# C(A) = 77774
		INDEX	5777
		6	SCONTS		# C(A) =  -0 WITH UNDERFLOW
		TS	SKEEP1
		TC	ERRORS
		AD	SKEEP1		# C(A) = -1
		AD	OVCTR		# C(A) = -1+2
		TC	-ONECHK -1

# NOT POSSIBLE TO CHECK WOVI PULSE IN NXI1
# START WOVI PULSE CHECK AND INHINT RELINT CHECK
RUPTCHK		INDEX	INHINT
		CAF	SCON0
		TS	0024		# ZRUPT
		INDEX	RELINT
		AD	TIME1
		TS	SKEEP1
TENMS		CS	SKEEP1		# CHECK FOR NEXT PULSE TP TIME1
		AD	TIME1
		CCS	A
		CCS	A
		TC	RUPTCHK		# START AGAIN, TIMING IS OFF DUE TO RUPT
		TC	+2		# 10 MS PULSE HAS ARRIVED AT TIME1
		TC	TENMS
		CAF	TM1WAIT		# START 7 TO 8 MS WAIT
7-8WAIT		CCS	A
		TC	7-8WAIT
		INDEX	INHINT
		CCS	0024		# ZRUPT
		TC	RUPTCHK		# THERE WAS AN INTERRUPT, START AGAIN
		CAF	SCON1
		TC	WAITLIST
		CADR	TSKADRS
		XCH	SCON+MAX
		AD	OVCON		# WILL STAY IN OVERFLOW, UNDERFLOW FOR
		INDEX	RELINT		# APPROXIMATELY 3 MS
WAIT1		CCS	A
		AD	SCON2
		TC	+2
		TC	WOVIRPT
		INDEX	5777
## Page 271
		6	SCONMAX		# SU -0
		XCH	A
		INDEX	SCON0
		CS	A
		MASK	A
		CS	A
		TS	A
		TC	ERRORS
		TC	WAIT1
WOVIRPT		INDEX	INHINT
		TS	SKEEP1
SCONTS		OCTAL	37775
		INDEX	RELINT
# INTERRUPT SHOULD APPEAR BEFORE NEXT INSTRUCTION
		TC	SOPTION1	# END OF PULSES CHECK
TSKADRS		CS	0024		# C(ZRUPT) = ADDRESS OF TSKADRS
		AD	ZRUPTCON
		TC	-ZEROCHK
		XCH	SCOUNT		# ADD +1 TO SCOUNT REGISTER AT THIS
		AD	SCON1		# POINT OF SELF-CHECK.
		XCH	SCOUNT
		TC	TASKOVER


SOPTION1	CCS	SMODE		# 3 OPTIONS OF SELF-CHECK
		TC	SMODECHK	# END OF PULSES ONLY CHECK
		TC	SMODECHK
		TC	+1		# CONTINUE IF C(SMODE) IS A NEG. NUMB5R

# COUNTS DOWN 15 BIT NUMBER (APPROXIMATELY 10 SECONDS)
COUNTCHK	CS	SCON+MAX
		TS	SKEEP5
COUNTS		TS	Q
		CCS	Q
		TC	-NMBR
SCONSU		OCTAL	37776
		TC	+2
		TC	OFCOUNT
		AD	SKEEP5
		TC	-ONECHK
		CCS	NEWJOB
		TC	DUMEXIT
		CS	SKEEP5
		AD	SCONMAX		# -0
		TS	SKEEP4
		TC	COUNTS
-NMBR		CS	A
		TS	SKEEP5
		AD	SKEEP4
		TC	-ONECHK -1
## Page 272
		CS	SKEEP5
		CS	A
		TC	COUNTS

# COUNTS DOWN OVERFLOW NUMBER (APPROXIMATELY 3.5 SECONDS)
OFCOUNT		TS	SKEEP7		# +0
		CAF	SCON+MAX
		AD	A
COUNTSOF	AD	SCON1
		INHINT
		XCH	Q
		CCS	Q
		TS	SKEEP6
		TC	ENDOF
		RELINT
		AD	SKEEP7
		TS	SKEEP7
		TC	+2
		TC	ERRORS
		CCS	NEWJOB
		TC	DUMEXIT
		CAF	SCON+MAX
		AD	SKEEP6
		TC	COUNTSOF
ENDOF		CS	A
		RELINT
		AD	SKEEP7
		TC	-ZEROCHK

# REGISTER 1777 ALWAYS HOLDS LOWEST (X-1) ADDRESS JUST CHECKED
# REGISTER 1776 HOLDS BEFORE CONTENTS OF X
# REGISTER 1775 HOLDS BEFORE CONTENTS OF X-1
# REGISTER 1774 IS STARTING ADDRESS
# PUTS OWN ADDRESS IN REGISTERS OCT 1774 THOUGH OCT 60 (APPROX.  1.2 SEC)
ERASCHK		CAF	CONERAS2	# 01774
		TS	1777
ERASLOOP	RELINT
		CCS	1777
		TS	1777
		INHINT
		NDX	1777
		CS	0001
		CS	A
		TS	1776		# PUT C(X) IN 1776
		NDX	1777
		CS	0000
		CS	A
		TS	1775		# PUT C(X-1) IN 1775
		CS	1777
		CS	A
## Page 273
		TS	ERESTORE	# IF RESTART, RESTORE C(X) AND C(X-1)
		NDX	1777
		TS	0000		# PUT OWN ADDRESS IN X-1
		AD	SCON1
		NDX	1777
		TS	0001		# PUT OWN ADDRESS IN X
		INDEX	1777
		CS	0001
		INDEX	1777
		AD	0000
		TC	-ONECHK
COMPLMNT	CS	1777
		INDEX	1777
		TS	0000		# PUTS COMPLEMENT OF ADDRESS IN X-1
		AD	SCON-1
		INDEX	1777
		TS	0001		# PUTS COMPLEMENT OF ADDRESS IN X
		INDEX	1777
		CS	0000
		INDEX	1777
		AD	0001
		TC	-ONECHK
		CS	1776
		CS	A
		NDX	1777
		TS	0001		# RESTORE C(X)
		CS	1775
		CS	A
		NDX	1777
		TS	0000		# RESTORE C(X-1)
		CS	SCONMAX
		TS	ERESTORE	# IF RESTART, DO NOT RESTORE C(X), C(X-1).
		CCS	NEWJOB
		TC	DUMEXIT
ENDERAS		CS	1777
		AD	CONERAS1	# +60 OCT
		CCS	A
SCON3/8		OCTAL	14000
SCON-3/8	OCTAL	63777
		TC	ERASLOOP
		INDEX	RELINT

# CS ALL REGISTERS FROM OCT 57 THROUGH OCT 20
# ALL COUNTERS, PLUS 4 SPARES, PLUS 4 RUPT REGISTERS.
# PLUS CYCLE AND SHIFT REGISTERS
CNTRCHK		CAF	LOW5
CNTRLOOP	TS	SKEEP1
		AD	CONCNTR1	# +20 OCT
		INDEX	A
		CS	0000
## Page 274
		CCS	SKEEP1
		TC	CNTRLOOP

CYCLSHFT	CAF	CONC+S1
		TS	CYR		# C(CYR) = 12525
		TS	CYL		# C(CYL) = 52524
		TS	SR		# C(SR) = 12525
		TS	SL		# C(SL) = 12524
		AD	CYR
		AD	CYL
		AD	SR
		AD	SL
		AD	CONC+S2		# C(A) = -1
		TC	-ONECHK
		
		XCH	SCOUNT +1	# ADD +1 TO SCOUNT +1 REGISTER AT THIS
		AD	SCON1		# POINT OF SELF-CHECK
		XCH	SCOUNT +1
SOPTION2	CCS	SMODE		# TWO OPTIONS LEFT
		TC	COUNTCHK
		TC	SMODECHK
		TC	SMODECHK	# END OF PULSES + SC + ERASABLE CHECK
		TC	ROPECHK		# CONTINUE WITH SELF-CHECK

# THE BNKCON CONSTANTS (BANK NUMBERS) ARE USED BY ROPECHK AND SHOWSUM
# THEY MUST BE IN THE FOLLOWING TABLE FORM
BNKCON1		OCTAL	02000
BNKCON2		OCTAL	04000
BNKCON3		OCTAL	06000
BNKCON4		OCTAL	10000
BNKCON5		OCTAL	12000
BNKCON6		OCTAL	14000
BNKCON7		OCTAL	16000
BNKCON10	OCTAL	20000
BNKCON11	OCTAL	22000
BNKCON12	OCTAL	24000
BNKCON13	OCTAL	26000
BNKCON14	OCTAL	30000
BNKCON21	OCTAL	42000
BNKCON22	OCTAL	44000
BNKCON23	OCTAL	46000
BNKCON24	OCTAL	50000
BNKCON25	OCTAL	52000
BNKCON26	OCTAL	54000
BNKCON27	OCTAL	56000
BNKCON30	OCTAL	60000
BNKCON31	OCTAL	62000
BNKCON32	OCTAL	64000
BNKCON33	OCTAL	66000
BNKCON34	OCTAL	70000
## Page 275
BANKSTOP	OCTAL	00000		# PUT +0 AFTER LAST BANK TO BE CHECKED

# TAKES BETWEEN 17 AND 20 SECONDS FOR ROPECHK TO GO THROUGH ALL BANKS.
# INITIALIZE 2OPTIONS TO -1 TO PERFORM ROPECHK
# SKEEP1 HOLDS SUM
# SKEEP2 HOLDS PRESENT CONTENTS OF ADDRESS IN ROPECHK AND SHOWSUM ROUTINES
# SKEEP2 HOLDS ACTUAL BANK NUMBER USED IN THE BANK REGISTER BUT CYCLED 5
# PLACES LEFT FOR DISPLAY IN SHOWSUM ROUTINE
# SKEEP3 HOLDS PRESENT ADDRESS (02000 TO 05777 IN FXFX BANKS)
#			       (00000 TO 01777 IN FXSW BANKS)
# SKEEP3 HOLDS BUGGER WORD FOR DISPLAY IN SHOWSUM ROUTINE
# SKEEP4 HOLDS ADDRESS OF BANK NUMBER
# SKEEP5 COUNTS TWO SUCCESSIVE TC SELF WORDS
# SKEEP6 HOLDS END OF BANK NUMBERS
# SKEEP7 COUNTS DOWN FIXED FIXED BANKS
ROPECHK		CS	SCON1
		TS	2OPTIONS
FXFXCHK		CAF	FXCON1		# 43776
		TS	SKEEP6
		CAF	BNKCON1		# 02000
		TS	SKEEP3
		CAF	STBNKCON
		TS	SKEEP4
		CAF	SCON1
		TS	SKEEP7
FXFXBNKS	CAF	SCON0
		TS	SKEEP1
		CAF	SCON2
		TS	SKEEP5		# COUNTS DOWN TWO TC SELF WORDS
FXADRS		INDEX	SKEEP3
		CAF	0000
		TC	ADSUM
		TC	ADRSCHK
		
BANK2		TS	SKEEP7
		CAF	FXCON2		# 45776
		TS	SKEEP6
		CAF	BNKCON2		# 04000
		TS	SKEEP3
		TC	FXFXBNKS
		
FXSWBNKS	CAF	SCON2
		TS	SKEEP5		# COUNTS DOWN TWO TC SELF WORDS
		CAF	SCON0
		TS	SKEEP1
		TS	SKEEP3
SWADRS		AD	SKEEP3
		INDEX	SKEEP4
		AD	0000
		TC	DATACALL
## Page 276
		TC	ADSUM
		AD	BNKCON3		# 06000
		TC	ADRSCHK

# SUBROUTINES ADRS+1, ADRSCHK, OPTION, NXTBNK, ADSUM, AND BNKCHK ARE
# USED BY BOTH FXFX AND FXSW BANKS
ADRS+1		XCH	SKEEP3
		AD	SCON1
		TS	SKEEP3
		CCS	SKEEP7
		TC	FXADRS
		TC	FXADRS
		TC	SWADRS
		
ADRSCHK		CCS	A
		TC	CONTINU
		TC	CONTINU
		TC	CONTINU
		CCS	SKEEP5
		TS	SKEEP5
		TC	CONTINU +5
CONTINU		CCS	SKEEP5
		TC	+2
		TC	SOPTION
		CAF	SCON2
		TS	SKEEP5		# MAKES SURE TWO CONSECUTIVE TC SELF WORDS
		CCS	NEWJOB
		TC	DUMEXIT
		CS	SKEEP3
		AD	SKEEP6
		TS	A		# UNDERFLOW AT END OF BANK
		TC	ADRS+1		# STAY IN SAME BANK
		
SOPTION		CCS	2OPTIONS
		TC	SDISPLAY
		TC	NXTBNK
		TC	BNKCHK
		TC	-ONECHK
		
NXTBNK		XCH	SKEEP4
		AD	SCON1
		TS	SKEEP4
		CCS	SKEEP7
		TC	BANK2
		TC	+1
		CS	SCON1
		TS	SKEEP7
		CAF	SWCON		# 41776
		TS	SKEEP6
ENDBANKS	INDEX	SKEEP4
## Page 277
		CS	0000
		CCS	A
		TC	FXSWBNKS
STBNKCON	ADRES	BNKCON1		# CONSTANT. STARTING ADDRESS OF BANK LIST
		TC	FXSWBNKS
		CCS	2OPTIONS	# END OF FIXED MEMORY CHECKING
		TC	SHOWSUM		# END OF SHOWSUM, START AGAIN
SWCON		OCTAL	41776		# CONSTANT
		TC	1/2OPTN		# END OF BANK SUMCHECKING SUBROUTINE
		
ADSUM		TS	SKEEP2
		AD	SKEEP1
		TS	SKEEP1
		CAF	SCON0
		AD	SKEEP1
		TS	SKEEP1
		CS	SKEEP2
		AD	SKEEP3
		TC	Q
		
		
BNKCHK		XCH	Q
		TS	QADRS
		CCS	SKEEP1
		TC	+4
		TC	ERRORS
		TC	+2
		TC	ERRORS
		TS	SKEEP1
		INDEX	SKEEP4
		CAF	0000
		TC	LEFT5		# CYCLES LEFT 5 PLACES
		CS	A
		AD	SKEEP1
		TC	QADRS
FXCON1		OCTAL	43776		# CONSTANT
FXCON2		OCTAL	45776		# CONSTANT

# INITIALIZE 2OPTIONS TO +1 TO PERFORM SHOWSUM 
# START OF ROUTINE THAT DISPLAYS SUM OF EACH BANK
SHOWSUM		CAF	SCON1
		TS	2OPTIONS	# SHOWSUM OPTION
		CAF	SCON0
		TS	SMODE		# PUT SELF-CHECK TO SLEEP
		INDEX	INHINT
		CAF	PRIO2
		TC	NOVAC
		CADR	FXFXCHK
		INDEX	RELINT
		TC	ENDOFJOB
## Page 278
SDISPLAY	INDEX	SKEEP4
		CAF	0000
		TC	LEFT5		# CYCLES LEFT 5 PLACES
		TS	SKEEP2		# HOLDS BANK NUMBER FOR DSKY DISPLAY
		CCS	SKEEP7		# 12 INSTRUCTIONS TO PUT BUGGER WORD
		TC	FXFXWORD	# IN SKEEP3.
		TC	FXFXWORD
		CS	SKEEP3		# GETS FXSW BUGGER WORD
		CS	A
		INDEX	SKEEP4
		AD	0000
		TC	DATACALL
		TC	+3
FXFXWORD	INDEX	SKEEP3		# GETS FXSW BUGGER WORD
		CAF	0000
		TS	SKEEP3		# SKEEP3 NOW HOLDS BUGGER WORD
		TC	GRABDSP
		TC	PREGBSY
NOKILL		CAF	SUMADRS
		TS	MPAC +2
		CAF	VNCON
		TC	NVSUB
		TC	SBUSY
		TC	BANKCALL
		CADR	FLASHON
		TC	ENDIDLE
		TC	+3		# FINISHED WITH SHOWSUM
		TC	SALLOW		# PROCEED TO NEXT BANK
		TC	NOKILL		# SO CAN LOAD WITHOUT KILLING SHOWSUM.
		TC	FREEDSP
		TC	ENDOFJOB
		
SALLOW		TC	FREEDSP		# ALLOWS ANOTHER JOB TO DISPLAY. LEAVES
		TC	NXTBNK		# SUM IN DSKY FOR 10 SEC. AFTER PROC. VERB
		
SBUSY		CAF	SCADR
		TC	NVSUBUSY
		
1/2OPTN		CCS	SMODE
		TC	+4		# STAY IN ROPECHK LOOP
		TC	SOPTION3 -3
		TC	SMODECHK	# SHOULD NOT COME HERE
		TC	MPNMBRS		# CONTINUE WITH SELF-CHECK
		XCH	SCOUNT +2
		AD	SCON1
		XCH	SCOUNT +2
		TC	ROPECHK

# MULTIPLY SUBROUTINES TAKE APPROXIMATELY 30 SECONDS
# (37777) X (37777 THROUGH 00001)
## Page 279
# C(A) COUNTS DOWN. C(LP) COUNTS UP.
MPNMBRS		CAF	SCON+MAX
		TS	SKEEP2
		CAF	SCON+MAX
		EXTEND
		MP	SKEEP2
		AD	LP		# C(A) = 37777
		CS	A
		AD	SCON+MAX
		TC	-ZEROCHK
		CCS	NEWJOB
		TC	DUMEXIT
		CCS	SKEEP2
		TS	SKEEP2
		CCS	SKEEP2
		TC	MPNMBRS +2
# (-1) X (37777 THROUGH 00001)
		CAF	SCON+MAX
		TS	SKEEP2
MPHIGH1		CAF	SCON-1
		EXTEND
		MP	SKEEP2		# C(A) = -0
		AD	LP
		AD	SKEEP2
		TC	-ZEROCHK
		CCS	NEWJOB
		TC	DUMEXIT
		CCS	SKEEP2
		TS	SKEEP2
		CCS	SKEEP2
		TC	MPHIGH1

# INTERCHANGE MULTIPLIER AND MULTIPLICAND
# (37777 THROUGH 00011) X (37777)
# C(A) COUNTS DOWN. C(LP) COUNTS UP.
		CAF	SCON+MAX
		TS	SKEEP1
MPAGAIN		CS	SKEEP1
		CS	A
		EXTEND
		MP	SCON+MAX
		AD	LP		# C(A) = 37777
		CS	A
		AD	SCON+MAX
		TC	-ZEROCHK
		CCS	NEWJOB
		TC	DUMEXIT
		CCS	SKEEP1
		TS	SKEEP1
		CCS	SKEEP1
## Page 280
		TC	MPAGAIN
# (37777 THROUGH 00001) X (-1)
		CAF	SCON+MAX
		TS	SKEEP1
MPHIGH2		CS	SKEEP1
		CS	A
		EXTEND
		MP	SCON-1
		AD	LP
		AD	SKEEP1
		TC	-ZEROCHK
		CCS	NEWJOB
		TC	DUMEXIT
		CCS	SKEEP1
		TS	SKEEP1
		CCS	SKEEP1
		TC	MPHIGH2
		TC	DV1

# THESE 2 CONSTANTS USED BY DIVIDE SUBROUTINES
DVCON1		OCTAL	37776
DVCON2		OCTAL	50001
# DIVIDE 1/4 BY 3/8
# ONCE THROUGH ALL DEVIDE SUBROUTINES TAKES APPROX. 0.012 SECONDS
# TOTAL TIME IN DEVIDE SUBROUTINES IS APPROX. 20 SECONDS
DV1		CAF	CONERAS2	# 01774
		TS	SKEEP7
DV1++		CAF	SCON3/8
		TS	Q
		CAF	SCON1/4
		EXTEND
		DV	Q		# C(A) = 25252
		TS	SKEEP1
		XCH	LP
		TS	SKEEP2
DV1+-		CS	Q		# +1/4
		EXTEND
		DV	SCON-3/8	# C(A) = 52525
		AD	SKEEP1		# C(A) = -0
		TS	SKEEP5
		XCH	LP
		TS	SKEEP3
DV1--		XCH	Q		# -1/4
		EXTEND
		DV	SCON-3/8
		TS	SKEEP1
		XCH	LP
		TS	SKEEP4
DV1-+		XCH	Q
		EXTEND
## Page 281
		DV	SCON3/8
		AD	SKEEP1		# C(A) = -0
		TS	SKEEP1
		CS	LP		# C(A) = 37776
		AD	SKEEP1		# C(A) = 37776
		AD	SKEEP2		# C(A) = 37777
		AD	SKEEP3		# C(A) = -0
		AD	SKEEP4		# C(A) = +1
		AD	SKEEP5		# C(A) = +1
		TC	-ONECHK -1

# DIVIDE INCREASING BIT POSITIONS BY 1/2  (13 DEVISIONS)
DV2		CAF	SCON1
DV2LOOP		TS	SKEEP2
		EXTEND
		DV	SCON1/2
		TS	SKEEP3
		AD	Q		# Q = -0
		TS	CYR
		CS	CYR
		AD	SKEEP2
		AD	LP
		TC	-ONECHK -1
		CS	SKEEP3
		AD	A
		TS	A		# OVERFLOW AT END OF DV2 SUBROUTINE
		TC	+2
		TC	DV3
		XCH	SKEEP3
		AD	SCON1
		TC	DV2LOOP

# DIVIDE SEPARATE DECREASING BIT POSITIONS BY 37777 (14DEVISIONS)
# AFTER C(A) = BEFORE C(A) AND AFTER C(Q) = -C(A)
DV3		CS	SCON+MAX
		TS	CYR		# C(CYR) = 20000
DV3LOOP		CS	CYR
		CS	A
		EXTEND
		DV	SCON+MAX
		TS	SKEEP4
		AD	Q
		TC	-ZEROCHK
		CCS	SKEEP4
		CCS	A
		TC	DV3LOOP

# DEVIDE 37776 BY 37776
# C(A) = +MAX FOR POSITIVE SIGN AND -MAX FOR NEGATIVE SIGN
# C(Q) = - ABSOLUTE VALUE OF DEVISION = 40001
## Page 282
DV4++		CAF	DVCON1		# 37776
		EXTEND
		DV	DVCON1		# C(A) = 37777    C(Q) = -37776
		AD	Q
		TC	-ONECHK -1
		XCH	LP		# C(LP) = +1
		TS	SKEEP5
		CS	DVCON1
		TS	SKEEP4
DV4+-		CAF	DVCON1
		EXTEND
		DV	SKEEP4		# C(A) = 40000  C(Q) = -37776
		CS	A
		AD	Q
		TC	-ONECHK -1
		AD	LP		# C(LP) = 40000
		AD	SKEEP5
		TS	SKEEP5		# -37776
DV4-+		CS	DVCON1
		EXTEND
		DV	DVCON1		# C(A) = 40000  C(Q) = -37776
		CS	A
		AD	Q
		TC	-ONECHK -1
		CS	LP		# C(LP) = 40001
		AD	SKEEP5
		TS	SKEEP5		# -0
DV4--		CS	DVCON1
		TS	SKEEP4
		EXTEND
		DV	SKEEP4		# C(A) = 37777  C(Q) = -37776
		AD	Q
		TC	-ONECHK -1
		CS	LP		# C(LP) = +1
		AD	SKEEP5
		TC	-ONECHK
		CCS	NEWJOB
		TC	DUMEXIT
		CCS	SKEEP7
		TC	+2
		TC	SOPTION3 -3
		TS	SKEEP7
		TC	DV1++		# BACK TO DEVIDE LOOP
		
		XCH	SCOUNT +2	# ADD +1 TO SCOUNT +2 REGISTER AT THIS
		AD	SCON1		# POINT OF SELF-CHECK
		XCH	SCOUNT +2
SOPTION3	CCS	SMODE
		TC	MPNMBRS		# STAY IN MPNMBRS LOOP
		TC	SMODECHK
## Page 283
		TC	SMODECHK	# SHOULD NOT COME HERE
		TC	SMODECHK	# END OF SELF-CHECK. START AGAIN
		
		BANK	1

## Page 284

# COMPUTER ACTIVITY LIGHT (GREEN LIGHT) MAINTENANCE.

SMODECHK	CCS	NEWJOB		# SEE IF ITS TIME FOR A CHANGE.
		TC	DUMEXIT
		
ADVAN		CCS	SMODE		# SEE IF SELF-CHECK IS WANTED
		TC	CCSCHK		# YES PULSES ONLY
		TC	SMODECHK
		TC	CCSCHK		# YES PULSES + SC + ERASABLE
		TC	CCSCHK		# YES ALL OF SELF-CHECK
		
		BANK	11
DUMEXIT		XCH	Q
		TS	QADRS		# STORE RETURN ADDRESS
		CS	TWO		# TURN ON GREEN LIGHT (COMP ACT) AND
		INHINT
		MASK	OUT1		# GO TO CHANG1.
		AD	TWO
		TS	OUT1
		TC	CHANG1
		
DUMYJOB		CS	TWO		# IDLING AGAIN- TURN OFF ACTIVITY LIGHT
		INHINT
		MASK	OUT1		# LIGHT.
		TS	OUT1
		RELINT
		TC	QADRS		# BACK TO CHECKING COMPUTER
		
DUMMYJOB	CAF	SMODECON	# ENTER AT SMODECON IF THERE IS A
		TS	QADRS		# FRESH START IR A GOJAM
		TC	DUMYJOB
SMODECON	ADRES	SMODECHK

## Page 285

# C-RELAY TESTER

CCHK		CAF	BIT15
		TS	DSPTAB +11D
		TS	DSPTAB +12D
		TS	DSPTAB +13D
		
		CAF	BIT7
		INHINT
		TC	WAITLIST
		CADR	CCHKA
		CAF	LCCHKB
		TC	JOBSLEEP
		
CCHKA		CAF	LCCHKB
		TC	JOBWAKE
		TC	TASKOVER
		
CCHKB		CAF	TWO
		TS	MPAC
		
		CAF	TEN
CCHK0		TS	MPAC +1

		INDEX	A
		CAF	BIT11
		AD	BIT15
		INDEX	MPAC
		TS	DSPTAB +11D
		
		CAF	BIT8
		INHINT
		TC	WAITLIST
		CADR	CCHK1
		
		CAF	LCCHK2
		TC	JOBSLEEP
		
CCHK1		CAF	LCCHK2
		TC	JOBWAKE
		TC	TASKOVER
		
CCHK2		XCH	IN3
		CCS	IN3
		TC	CCHKALM
		TC	CCHKALM
		TC	+2
		TC	CCHKALM
		
		CCS	MPAC +1
## Page 286
		TC	CCHK0
		
		CAF	BIT15		# TURN OFF LAST RELAY.
		INDEX	MPAC
		TS	DSPTAB +11D
		
		CCS	MPAC
		TC	CCHK0 -2
		CAF	BIT7
		INHINT
		TC	WAITLIST
		CADR	CCHKC
		CAF	LCCHKD
		TC	JOBSLEEP
		
CCHKC		CAF	LCCHKD
		TC	JOBWAKE
		TC	TASKOVER
		
CCHKD		XCH	IN3
		CCS	IN3
		TC	+4
		TC	+3
		TC	CCHKALM
		TC	CCHKALM
		
		CAF	SEVEN
		TS	MPAC +2
		CAF	CCHKNV
		TC	NVSUB
		TC	PRENVBSY
TSTOUT		TC	FREEDSP
		TC	NEWMODE		# REVERT TO MODE 00.
		OCT	0
		TC	ENDOFJOB
		
CCHKALM		TC	ALARM
		OCT	1104
		TC	ENDOFJOB
		
LCCHKB		CADR	CCHKB
LCCHK2		CADR	CCHK2
CCHKNV		OCT	00101
LCCHKD		CADR	CCHKD

## Page 287

# DSKY TESTER

DCHECK		CAF	TEN
DC9		TS	MPAC
		INDEX	MPAC
		CAF	DSKYCODE
		TS	MPAC +1
		INHINT
		COM
		TS	DSPTAB +9D
		CS	MID5
		MASK	MPAC +1
		COM
		TS	DSPTAB +7
		CS	BIT11
		MASK	MPAC +1
		COM
		TS	DSPTAB
		TS	DSPTAB +1
		TS	DSPTAB +2
		TS	DSPTAB +3
		TS	DSPTAB +4
		TS	DSPTAB +5
		TS	DSPTAB +6
		TS	DSPTAB +8D
		TS	DSPTAB +10D
		CAF	DCNOUT
		TS	NOUT
DCWAIT		CAF	BIT11		# 10.24 SEC WAIT
		TC	WAITLIST
		CADR	DC10
		CAF	LDC11
		TC	JOBSLEEP
		
DC10		CAF	LDC11
		TC	JOBWAKE
		TC	TASKOVER
		
DC11		CCS	MPAC
		TC	DC9
		
		TC	+2
		TC	DC+
		
		INHINT
		CS	6K		# - SIGNS.
		TS	DSPTAB
		TS	DSPTAB +3
		TS	DSPTAB +5
		TS	MPAC
## Page 288
		CAF	THREE
		TS	NOUT
		TC	DCWAIT
		
DC+		INHINT
		CS	6K
		TS	DSPTAB +1
		TS	DSPTAB +4
		TS	DSPTAB +6
		CS	BIT12
		TS	DSPTAB
		TS	DSPTAB +3
		TS	DSPTAB +5
		CAF	SIX
		TS	NOUT
		CAF	LOW5
		TS	OUT1		# TURNS ON DSKY LAMPS.
		RELINT
		CAF	BIT9
DC++		TS	MPAC		# KEEP GLIT ON FOR A WHILE.
		CAF	BIT11		# LOOPS FOR ABOUT 40 MS.
		CCS	A
		TC	-1
		CCS	NEWJOB
		TC	CHANG1
		CCS	MPAC
		TC	DC++
		TC	TSTOUT
		
DSKYCODE	OCT	04000		# BLANKS
		OCT	07265		# 00
		OCT	06143		# 11
		OCT	07471		# 22
		OCT	07573		# 33
		OCT	06757		# 44
		OCT	07736		# 55
		OCT	07634		# 66
		OCT	07163		# 77
		OCT	07675		# 88
		OCT	07777		# 99
DCNOUT		DEC	11
LDC11		CADR	DC11

## Page 289

# ENGINE-ON PROGRAM	FOLLOWING A +XX.XX SECOND DELAY OF LESS THAN 2 MINUTES, ENGINE WILL REMAIN ON FOR +XXX.XX

BROKYPRG	TC	GRABDSP
		TC	PREGBSY
		CAF	ONE
		TS	CUSSANG
		CAF	V21N24G
		TC	NVSUB
		TC	PRENVBSY
		TC	ENDIDLE
		TC	ENDOFJOB
		TC	-5
		XCH	DSPTEM1
		XCH	LONGTIME
		XCH	DSPTEM1 +1
		XCH	LONGTIME +1
		TS	PLOW
		CCS	CUSSANG
		TC	BROKYPRG +3
		XCH	PLOW
		TC	WAITLIST
		CADR	ENGNON
		TC	FREEDSP
		TC	ENDOFJOB
ENGNON		CS	BIT13
		MASK	OUT1
		AD	BIT13
		TS	OUT1
		CAF	ENGOFLOC
		TS	CALLCADR
		TC	IBNKCALL
		CADR	LONGCALL
		TC	TASKOVER
ENGNOFF		CS	BIT13
		MASK	OUT1
		TS	OUT1
		TC	TASKOVER
V21N24G		OCT	02124
ENGOFLOC	CADR	ENGNOFF