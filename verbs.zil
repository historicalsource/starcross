"VERBS for
			   Interlogic SF Game
       (c) Copyright 1981,1982 Infocom, Inc.  All Rights Reserved
"

"SUBTITLE DESCRIBE THE UNIVERSE"

"SUBTITLE SETTINGS FOR VARIOUS LEVELS OF DESCRIPTION"

<GLOBAL VERBOSE <>>
<GLOBAL SUPER-BRIEF <>>
<GDECL (VERBOSE SUPER-BRIEF) <OR ATOM FALSE>>

<ROUTINE V-VERBOSE ()
	 <SETG VERBOSE T>
	 <SETG SUPER-BRIEF <>>
	 <TELL "Maximum verbosity." CR>>

<ROUTINE V-BRIEF ()
	 <SETG VERBOSE <>>
	 <SETG SUPER-BRIEF <>>
	 <TELL "Brief descriptions." CR>>

<ROUTINE V-SUPER-BRIEF ()
	 <SETG SUPER-BRIEF T>
	 <TELL "Super-brief descriptions." CR>>

\

"SUBTITLE DESCRIBERS"

<ROUTINE V-LOOK ()
	 <COND (<DESCRIBE-ROOM T>
		<DESCRIBE-OBJECTS T>)>>

<ROUTINE V-FIRST-LOOK ()
	 <COND (<DESCRIBE-ROOM>
		<COND (<NOT ,SUPER-BRIEF> <DESCRIBE-OBJECTS>)>)>>

<ROUTINE V-EXAMINE ()
	 <COND (<GETP ,PRSO ,P?TEXT>
		<TELL <GETP ,PRSO ,P?TEXT> CR>)
	       (<OR <FSET? ,PRSO ,CONTBIT>
		    <FSET? ,PRSO ,DOORBIT>>
		<V-LOOK-INSIDE>)
	       (ELSE
		<TELL "I see nothing special about the "
		      D ,PRSO "." CR>)>>

<GLOBAL LIT <>>

<ROUTINE DESCRIBE-ROOM ("OPTIONAL" (LOOK? <>) "AUX" V? STR AV)
	 <SET V? <OR .LOOK? ,VERBOSE>>
	 <COND (<NOT ,LIT>
		<TELL
"It is pitch black.  You are likely to be eaten by a grue." CR>
		<RETURN <>>)>
	 <COND (<NOT <FSET? ,HERE ,TOUCHBIT>>
		<FSET ,HERE ,TOUCHBIT>
		<SET V? T>)>
	 <COND (<IN? ,HERE ,ROOMS> <TELL D ,HERE CR>)>
	 <COND (<OR .LOOK? <NOT ,SUPER-BRIEF>>
		<SET AV <LOC ,WINNER>>
		<COND (<FSET? .AV ,VEHBIT>
		       <TELL "(You are in the " D .AV ".)" CR>)>
		<COND (<AND .V? <APPLY <GETP ,HERE ,P?ACTION> ,M-LOOK>>
		       <RTRUE>)
		      (<AND .V? <SET STR <GETP ,HERE ,P?LDESC>>>
		       <TELL .STR CR>)
		      (T <APPLY <GETP ,HERE ,P?ACTION> ,M-FLASH>)>
		<COND (<AND <NOT <==? ,HERE .AV>> <FSET .AV ,VEHBIT>>
		       <APPLY <GETP .AV ,P?ACTION> ,M-LOOK>)>)>
	 <COND (<AND <NOT <FSET? ,HERE ,ONBIT>> ,ALWAYS-LIT>
		<TELL
"The room is lit by an emergency lighting system." CR>)>
	 T>

<ROUTINE DESCRIBE-OBJECTS ("OPTIONAL" (V? <>))
	 <COND (,LIT
		<COND (<FIRST? ,HERE>
		       <PRINT-CONT ,HERE <SET V? <OR .V? ,VERBOSE>> -1>)>)
	       (ELSE
		<TELL "I can't see anything in the dark." CR>)>>

"DESCRIBE-OBJECT -- takes object and flag.  if flag is true will print a
long description (fdesc or ldesc), otherwise will print short."

<ROUTINE DESCRIBE-OBJECT (OBJ V? LEVEL "AUX" (STR <>) AV)
	 <COND (<AND <0? .LEVEL>
		     <APPLY <GETP .OBJ ,P?DESCFCN> ,M-OBJDESC>>
		<RTRUE>)
	       (<AND <0? .LEVEL>
		     <OR <AND <NOT <FSET? .OBJ ,TOUCHBIT>>
			      <SET STR <GETP .OBJ ,P?FDESC>>>
			 <SET STR <GETP .OBJ ,P?LDESC>>>>
		<TELL .STR>)
	       (<0? .LEVEL>
		<TELL "There is a " D .OBJ " here.">)
	       (ELSE
		<TELL <GET ,INDENTS .LEVEL>>
		<TELL "A " D .OBJ>
		<COND (<FSET? .OBJ ,WEARBIT> <TELL " (being worn)">)
		      (<==? .OBJ ,SAFETY-LINE>
		       <COND (<AND ,THIS-END ,THAT-END>
			      <TELL " (connecting the suit and a hook)">)
			     (,THIS-END <TELL " (tied to the suit)">)
			     (,THAT-END <TELL " (tied to a hook)">)>)>)>
	 <COND (<AND <0? .LEVEL>
		     <SET AV <LOC ,WINNER>>
		     <FSET? .AV ,VEHBIT>>
		<TELL " (outside the " D .AV ")">)>
	 <CRLF>
	 <COND (<AND <SEE-INSIDE? .OBJ> <FIRST? .OBJ>>
		<PRINT-CONT .OBJ .V? .LEVEL>)>>

<ROUTINE PRINT-CONT (OBJ "OPTIONAL" (V? <>) (LEVEL 0)
		     "AUX" Y 1ST? AV STR (PV? <>) (INV? <>))
	 #DECL ((OBJ) OBJECT (LEVEL) FIX)
	 <COND (<NOT <SET Y <FIRST? .OBJ>>> <RTRUE>)>
	 <COND (<AND <SET AV <LOC ,WINNER>> <FSET? .AV ,VEHBIT>>
		T)
	       (ELSE <SET AV <>>)>
	 <SET 1ST? T>
	 <COND (<EQUAL? ,WINNER .OBJ <LOC .OBJ>>
		<SET INV? T>)
	       (ELSE
		<REPEAT ()
			<COND (<NOT .Y> <RETURN <NOT .1ST?>>)
			      (<==? .Y .AV> <SET PV? T>)
			      (<==? .Y ,WINNER>)
			      (<AND <NOT <FSET? .Y ,INVISIBLE>>
				    <NOT <FSET? .Y ,TOUCHBIT>>
				    <SET STR <GETP .Y ,P?FDESC>>>
			       <COND (<NOT <FSET? .Y ,NDESCBIT>>
				      <TELL .STR CR>)>
			       <COND (<AND <SEE-INSIDE? .Y>
					   <NOT <GETP <LOC .Y> ,P?DESCFCN>>
					   <FIRST? .Y>>
				      <PRINT-CONT .Y .V? 0>)>)>
			<SET Y <NEXT? .Y>>>)>
	 <SET Y <FIRST? .OBJ>>
	 <REPEAT ()
		 <COND (<NOT .Y>
			<COND (<AND .PV? .AV <FIRST? .AV>>
			       <PRINT-CONT .AV .V? .LEVEL>)>
			<RETURN <NOT .1ST?>>)
		       (<EQUAL? .Y .AV ,ADVENTURER>)
		       (<AND <NOT <FSET? .Y ,INVISIBLE>>
			     <OR .INV?
				 <FSET? .Y ,TOUCHBIT>
				 <NOT <GETP .Y ,P?FDESC>>>>
			<COND (<NOT <FSET? .Y ,NDESCBIT>>
			       <COND (.1ST?
				      <COND (<FIRSTER .OBJ .LEVEL>
					     <COND (<L? .LEVEL 0>
						    <SET LEVEL 0>)>)>
				      <SET LEVEL <+ 1 .LEVEL>>
				      <SET 1ST? <>>)>
			       <DESCRIBE-OBJECT .Y .V? .LEVEL>)
			      (<AND <FIRST? .Y> <SEE-INSIDE? .Y>>
			       <PRINT-CONT .Y .V? .LEVEL>)>)>
		 <SET Y <NEXT? .Y>>>>

<ROUTINE FIRSTER (OBJ LEVEL)
	 <COND (<==? .OBJ ,WINNER>
		<TELL "You are carrying:" CR>)
	       (<NOT <IN? .OBJ ,ROOMS>>
		<COND (<G? .LEVEL 0>
		       <TELL <GET ,INDENTS .LEVEL>>)>
		<COND (<==? .OBJ ,TRASH-BIN>
		       <TELL
"Among the trash near the top of the bin you see:" CR>)
		      (<FSET? .OBJ ,SURFACEBIT>
		       <TELL
"Sitting on the " D .OBJ " is:" CR>)
		      (ELSE
		       <TELL
"The " D .OBJ " contains:" CR>)>)
	       (<FSET? .OBJ ,RMUNGBIT>
		<TELL
"Floating nearby is: " CR>)>>

\

"SUBTITLE SCORING"

<GLOBAL MOVES 0>
<GLOBAL SCORE 0>
<GLOBAL WON-FLAG <>>

<ROUTINE SCORE-UPD (NUM)
	 #DECL ((NUM) FIX)
	 <SETG SCORE <+ ,SCORE .NUM>>
	 T>

<ROUTINE SCORE-OBJ (OBJ)
	 #DECL ((OBJ) OBJECT (TEMP) FIX)
	 <COND (<G? <GETP .OBJ ,P?VALUE> 0>
		<FSET .OBJ ,TOUCHBIT>
		<SCORE-UPD <GETP .OBJ ,P?VALUE>>
		<PUTP .OBJ ,P?VALUE 0>)>>

<GLOBAL SCORE-MAX 400>

<ROUTINE V-SCORE ("OPTIONAL" (ASK? T))
	 #DECL ((ASK?) <OR ATOM FALSE>)
	 <TELL "Your score ">
	 <COND (.ASK? <TELL "would be ">) (ELSE <TELL "is ">)>
	 <TELL N ,SCORE>
	 <TELL " (total of ">
	 <TELL N ,SCORE-MAX>
	 <TELL " points), in ">
	 <TELL N ,MOVES>
	 <COND (<1? ,MOVES> <TELL " move.">) (ELSE <TELL " moves.">)>
	 <CRLF>
	 <TELL "This score gives you the rank of ">
	 <COND (,WON-FLAG <TELL "Galactic Overlord">)
	       (<G? ,SCORE 360> <TELL "Cluster Admiral">)
	       (<G? ,SCORE 320> <TELL "System Captain">)
	       (<G? ,SCORE 240> <TELL "Planetary Commodore">)
	       (<G? ,SCORE 160> <TELL "Lieutenant">)
	       (<G? ,SCORE 80> <TELL "Ensign">)
	       (<G? ,SCORE 40> <TELL "Space Cadet">)
	       (T <TELL "Beginner">)>
	 <TELL "." CR>
	 ,SCORE>

<ROUTINE FINISH ()
	 <V-SCORE>
	 <QUIT>>

<ROUTINE V-QUIT ("OPTIONAL" (ASK? T) "AUX" SCOR)
	 #DECL ((ASK?) <OR ATOM <PRIMTYPE LIST>> (SCOR) FIX)
	 <V-SCORE>
	 <COND (<OR <AND .ASK?
			 <TELL
"Do you wish to leave the game? (Y is affirmative): ">
			 <YES?>>
		    <NOT .ASK?>>
		<QUIT>)
	       (ELSE <TELL "Ok." CR>)>>

<ROUTINE YES? ()
	 <PRINTI ">">
	 <READ ,P-INBUF ,P-LEXV>
	 <COND (<EQUAL? <GET ,P-LEXV 1> ,W?YES ,W?Y>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE V-VERSION ("AUX" (CNT 17))
	 <TELL
"STARCROSS: INTERLOGIC Science Fiction|
Copyright (c) 1982 by Infocom, Inc.  All rights reserved.|
STARCROSS and INTERLOGIC are trademarks of Infocom, Inc.|
Release ">
	 <PRINTN <BAND <GET 0 1> *3777*>>
	 <TELL " / Serial number ">
	 <REPEAT ()
		 <COND (<G? <SET CNT <+ .CNT 1>> 23>
			<RETURN>)
		       (T
			<PRINTC <GETB 0 .CNT>>)>>
	 <CRLF>>

<ROUTINE V-AGAIN ("AUX" OBJ)
	 <COND (<==? ,L-PRSA ,V?WALK>
		<DO-WALK ,L-PRSO>)
	       (T
		<SET OBJ
		     <COND (<AND ,L-PRSO <NOT <LOC ,L-PRSO>>>
			    ,L-PRSO)
			   (<AND ,L-PRSI <NOT <LOC ,L-PRSI>>>
			    ,L-PRSI)>>
		<COND (.OBJ
		       <TELL "I can't see the " D .OBJ " anymore." CR>
		       <RFATAL>)
		      (T
		       <PERFORM ,L-PRSA ,L-PRSO ,L-PRSI>)>)>>

\

"SUBTITLE DEATH AND TRANSFIGURATION"

<GLOBAL DEATHS 0>
<GLOBAL LUCKY 1>

<ROUTINE JIGS-UP (DESC "OPTIONAL" (PLAYER? <>))
 	 #DECL ((DESC) STRING (PLAYER?) <OR ATOM FALSE>)
 	 <TELL .DESC CR>
	 <COND (<NOT <==? ,ADVENTURER ,WINNER>>
		<TELL "
|    ****  The " D ,WINNER " has died  ****
|
|">
		<REMOVE ,WINNER>
		<SETG WINNER ,ADVENTURER>
		<SETG HERE <LOC ,WINNER>>
		<RFATAL>)>
	 <PROG ()
	       <SCORE-UPD -10>
	       <TELL "
|    ****  You have died  ****
|
|">
	         <SETG DEATHS <+ ,DEATHS 1>>
		 <COND (<==? ,DEATHS 4>
			<COND (,DOCKED?
			       <TELL
"The expressionless voice seems despairing as it says \"Four failures.
They would not be pleased. Such promising candidates, too. If only...\"
The voice trails off into background hiss. Nothing more happens, ever." CR>)
			      (ELSE
			       <TELL
"This time, you aren't given another chance." CR>)>
			<FINISH>)
		       (<G? ,POISON-COUNT 3>
			<TELL
"An expressionless voice seems to be trying to express outrage, but not
successfully. \"The candidate has not made the necessary repairs in time.
This is a disaster. All are now dead, and repairs are
not possible. They would not approve. This area will be marked, that is
certain.\" Everything fades to black, and silence reigns." CR>
			<FINISH>)>
		 <RANDOMIZE-OBJECTS>
		 <COND (<FSET? ,RED-THREE ,TOUCHBIT>
			<MOVE ,WINNER ,RED-THREE>)
		       (ELSE
			<SETG IN-ARTIFACT? <>>
			<FCLEAR ,AIRLOCK-OUTER ,OPENBIT>
			<FCLEAR ,AIRLOCK-INNER ,OPENBIT>
			<MOVE ,WINNER ,SPACESHIP-BRIDGE>
			<MOVE ,SPACESUIT ,SPACESHIP-STORES>)>
		 <COND (,DOCKED?
			<TELL
"You hear, if that is the right word, an expressionless voice. It seems
to be inside your head.  \"This is not promising. The candidate does not
deserve another chance, but the instructions are explicit. There are not
even any more docking ports. They would be disappointed if they knew.\"
You wake to a brief glimpse of a pallet (on which you are lying) surrounded
by metallic threads. The whole apparatus begins to vibrate and you feel very
dizzy. As you lose consciousness, you realize that you can't see the rest of
your body. There is a feeling of dislocation, and then..." CR>)
		       (ELSE
			<TELL
"You wake to find yourself alive, on board the \"Starcross.\" It appears
you have been given another chance." CR>)>
		 <SETG LIT T>
		 <FCLEAR ,SPACESUIT ,WEARBIT>
		 <SETG SUIT-ON? <>>
		 <SETG THIS-END <>>
		 <SETG THAT-END <>>
		 <SETG P-CONT <>>
		 <SETG COUNTDOWN <>>
		 <SETG R-VALUE 0>
		 <SETG PHI-VALUE 0>
		 <SETG THETA-VALUE 0>
		 <SETG LOST <>>
		 <SETG GIVE-UP <>>
		 <KILL-INTERRUPTS>
		 <RFATAL>>>

<ROUTINE RANDOMIZE-OBJECTS ("AUX" (R <>) F N L)
	 <SET N <FIRST? ,WINNER>>
	 <REPEAT ()
		 <SET F .N>
		 <COND (<NOT .F> <RETURN>)>
		 <SET N <NEXT? .F>>
		 <COND (<FSET? ,RED-THREE ,TOUCHBIT>
			<COND (<FSET? .F ,KEYBIT> <MOVE .F ,HERE>)
			      (ELSE <MOVE .F ,RED-LOCK>)>)
		       (ELSE
			<COND (<FSET? .F ,KEYBIT> <MOVE .F ,HERE>)
			      (ELSE
			       <MOVE .F ,SPACESHIP-STORES>)>)>>>

<ROUTINE KILL-INTERRUPTS ()
	 <DISABLE <INT I-BURN>>
	 <RTRUE>>

<ROUTINE V-RESTORE ()
	 <COND (<RESTORE>
		<TELL "Ok." CR>
		<V-FIRST-LOOK>)
	       (T
		<TELL "Failed." CR>)>>

<ROUTINE V-SAVE ()
	 <COND (<SAVE>
	        <TELL "Ok." CR>)
	       (T
		<TELL "Failed." CR>)>>

<ROUTINE V-RESTART ()
	 <V-SCORE T>
	 <TELL "Do you wish to restart? (Y is affirmative): ">
	 <COND (<YES?>
		<TELL "Restarting." CR>
		<RESTART>
		<TELL "Failed." CR>)>>

<CONSTANT REXIT 0>
<CONSTANT UEXIT 1>
<CONSTANT NEXIT 2>
<CONSTANT FEXIT 3>
<CONSTANT CEXIT 4>
<CONSTANT DEXIT 5>

<CONSTANT NEXITSTR 0>
<CONSTANT FEXITFCN 0>
<CONSTANT CEXITFLAG 1>
<CONSTANT CEXITSTR 1>
<CONSTANT DEXITOBJ 1>
<CONSTANT DEXITSTR 1>

<ROUTINE V-WALK-AROUND ()
	 <TELL "Use directions for movement here." CR>>

<ROUTINE V-LAUNCH ()
	 <TELL "You can't launch that!" CR>>

<ROUTINE GO-NEXT (TBL "AUX" VAL)
	 #DECL ((TBL) TABLE (VAL) ANY)
	 <COND (<SET VAL <LKP ,HERE .TBL>>
		<GOTO .VAL>)>>

<ROUTINE LKP (ITM TBL "AUX" (CNT 0) (LEN <GET .TBL 0>))
	 #DECL ((ITM) ANY (TBL) TABLE (CNT LEN) FIX)
	 <REPEAT ()
		 <COND (<G? <SET CNT <+ .CNT 1>> .LEN>
			<RFALSE>)
		       (<==? <GET .TBL .CNT> .ITM>
			<COND (<==? .CNT .LEN> <RFALSE>)
			      (T
			       <RETURN <GET .TBL <+ .CNT 1>>>)>)>>>

<ROUTINE V-WALK ("AUX" PT PTS STR OBJ RM)
	 #DECL ((PT) <OR FALSE TABLE> (PTS) FIX (STR) <OR STRING FALSE>
		(OBJ) OBJECT (RM) <OR FALSE OBJECT>)
	 <COND (<NOT ,P-WALK-DIR>
		<PERFORM ,V?WALK-TO ,PRSO>
		<RTRUE>)
	       (<SET PT <GETPT ,HERE ,PRSO>>
		<COND (<==? <SET PTS <PTSIZE .PT>> ,UEXIT>
		       <GOTO <GETB .PT ,REXIT>>)
		      (<==? .PTS ,NEXIT>
		       <TELL <GET .PT ,NEXITSTR> CR>
		       <RFATAL>)
		      (<==? .PTS ,FEXIT>
		       <COND (<SET RM <APPLY <GET .PT ,FEXITFCN>>>
			      <GOTO .RM>)
			     (T
			      <RFATAL>)>)
		      (<==? .PTS ,CEXIT>
		       <COND (<VALUE <GETB .PT ,CEXITFLAG>>
			      <GOTO <GETB .PT ,REXIT>>)
			     (<SET STR <GET .PT ,CEXITSTR>>
			      <TELL .STR CR>
			      <RFATAL>)
			     (T
			      <TELL "You can't go that way." CR>
			      <RFATAL>)>)
		      (<==? .PTS ,DEXIT>
		       <COND (<FSET? <SET OBJ <GETB .PT ,DEXITOBJ>> ,OPENBIT>
			      <GOTO <GETB .PT ,REXIT>>)
			     (<SET STR <GET .PT ,DEXITSTR>>
			      <TELL .STR CR>
			      <RFATAL>)
			     (T
			      <TELL "The " D .OBJ " is closed." CR>
			      <THIS-IS-IT .OBJ>
			      <RFATAL>)>)>)
	       (<AND <NOT ,LIT> <PROB 75>>
		<JIGS-UP
"Oh, no! You have walked into the slavering fangs of a lurking grue!">)
	       (T
		<TELL "You can't go that way." CR>
		<RFATAL>)>>

<ROUTINE THIS-IS-IT (OBJ)
	 <SETG P-IT-OBJECT .OBJ>
	 <SETG P-IT-LOC ,HERE>>

<ROUTINE V-INVENTORY ()
	 <COND (<FIRST? ,WINNER> <PRINT-CONT ,WINNER>)
	       (T <TELL "You are empty handed." CR>)>>

<GLOBAL INDENTS
	<TABLE ""
	       "  "
	       "    "
	       "      "
	       "        "
	       "          ">>

\

<ROUTINE PRE-TAKE ()
	 <COND (<IN? ,PRSO ,WINNER> <TELL "You already have it." CR>)
	       (<AND <FSET? <LOC ,PRSO> ,CONTBIT>
		     <NOT <FSET? <LOC ,PRSO> ,OPENBIT>>>
		<TELL "I can't reach that." CR>
		<RTRUE>)
	       (<AND ,PRSI <NOT <==? ,PRSO ,SPEAR>>>
		<COND (<NOT <==? ,PRSI <LOC ,PRSO>>>
		       <TELL "It's not in that!" CR>)
		      (T
		       <SETG PRSI <>>
		       <RFALSE>)>)
	       (<==? ,PRSO <LOC ,WINNER>> <TELL "You are in it, loser!" CR>)>>

<ROUTINE V-TAKE ()
	 <COND (<==? <ITAKE> T>
		<TELL "Taken." CR>)>>

<GLOBAL FUMBLE-NUMBER 7>
<GLOBAL FUMBLE-PROB 8>

<ROUTINE TRYTAKE ()
	 <COND (<IN? ,PRSO ,WINNER> <RTRUE>)
	       (<AND <FSET? ,PRSO ,TRYTAKEBIT>
		     <GETP ,PRSO ,P?ACTION>>
		<PERFORM ,V?TAKE ,PRSO>
		<IN? ,PRSO ,WINNER>)
	       (ELSE <ITAKE>)>>

<ROUTINE ITAKE ("OPTIONAL" (VB T) "AUX" CNT OBJ WLOC)
	 #DECL ((VB) <OR ATOM FALSE> (CNT) FIX (OBJ) OBJECT)
	 <COND (<NOT <FSET? ,PRSO ,TAKEBIT>>
		<COND (.VB
		       <TELL <PICK-ONE ,YUKS> CR>)>
		<RFALSE>)
	       (<AND <NOT <IN? <LOC ,PRSO> ,WINNER>>
		     <G? <+ <WEIGHT ,PRSO> <WEIGHT ,WINNER>> ,LOAD-ALLOWED>>
		<COND (.VB
		       <TELL "Your load is too heavy." CR>)>
		<RFATAL>)
	       (<AND <G? <SET CNT <CCOUNT ,WINNER>> ,FUMBLE-NUMBER>
		     <PROB <* .CNT ,FUMBLE-PROB>>>
		<SET OBJ <FIRST? ,WINNER>>
		<SET OBJ <NEXT? .OBJ>>
		;"This must go!  Chomping compiler strikes again"
		<TELL
"Oh, no. The " D .OBJ " slips from your arms while taking the "
D ,PRSO " and both tumble to the ground." CR>
		<SET WLOC <LOC ,WINNER>>
		<COND (<==? ,PRSO ,UNDER-GLOBE>
		       <SETG UNDER-GLOBE <>>
		       <FCLEAR ,PRSO ,NDESCBIT>)>
		<COND (<OR <FSET? .WLOC ,RMUNGBIT>
			   <EQUAL? .WLOC
				   ,UP-A-TREE
				   ,TREETOP-ROOM
				   ,DRIVE-BUBBLE-ENTRANCE>
			   <EQUAL? .WLOC
				   ,CONTROL-BUBBLE-ENTRANCE>>
		       <PERFORM ,V?DROP .OBJ>
		       <MOVE ,PRSO ,WINNER>
		       <PERFORM ,V?DROP ,PRSO>)
		      (ELSE
		       <MOVE .OBJ .WLOC>
		       <MOVE ,PRSO .WLOC>)>
		<RFATAL>)
	       (T
		<MOVE ,PRSO ,WINNER>
		<FCLEAR ,PRSO ,NDESCBIT>
		<SCORE-OBJ ,PRSO>
		<FSET ,PRSO ,TOUCHBIT>
		<RTRUE>)>>

<GLOBAL YUKS
	<LTABLE
	 "A valiant attempt."
	 "You can't be serious."
	 "Not bloody likely."
	 "An interesting idea..."
	 "What a concept!">>

<ROUTINE PRE-PUT ()
	 <COND (<OR <IN? ,PRSO ,GLOBAL-OBJECTS>
		    <NOT <FSET? ,PRSO ,TAKEBIT>>>
		<TELL "Nice try." CR>)>>

<ROUTINE V-PUT ()
	 <COND (<OR <FSET? ,PRSI ,OPENBIT>
		    <OPENABLE? ,PRSI>
		    <FSET? ,PRSI ,VEHBIT>>)
	       (T
		<TELL "I can't do that." CR>
		<RTRUE>)>
	 <COND (<NOT <FSET? ,PRSI ,OPENBIT>>
		<TELL "The " D ,PRSI " isn't open." CR>)
	       (<==? ,PRSI ,PRSO>
		<TELL "How can you do that?" CR>)
	       (<IN? ,PRSO ,PRSI>
		<TELL "The " D ,PRSO " is already in the " D ,PRSI "." CR>)
	       (<G? <- <+ <WEIGHT ,PRSI> <WEIGHT ,PRSO>>
		       <GETP ,PRSI ,P?SIZE>>
		    <GETP ,PRSI ,P?CAPACITY>>
		<TELL "There's no room." CR>)
	       (<AND <NOT <HELD? ,PRSO>>
		     <NOT <TRYTAKE>>>
		<RTRUE>)
	       (T
		<SCORE-OBJ ,PRSO>
		<MOVE ,PRSO ,PRSI>
		<FSET ,PRSO ,TOUCHBIT>
		<TELL "Done." CR>)>>

<ROUTINE PRE-DROP ()
	 <COND (<==? ,PRSO <LOC ,WINNER>>
		<PERFORM ,V?DISEMBARK ,PRSO>
		<RTRUE>)>>

"SZAP => ZAP who WITH what"

<ROUTINE PRE-SZAP ()
	 <PERFORM ,V?ZAP ,PRSI ,PRSO>
	 <RTRUE>>

"ZAP => ZAP <weapon> <who>"

<ROUTINE PRE-ZAP ()
	 <COND (,PRSI <RFALSE>)
	       (<FSET? ,PRSO ,WEAPONBIT> <RFALSE>)
	       (<IN? ,ZAP-GUN ,WINNER>
		<PERFORM ,V?ZAP ,ZAP-GUN ,PRSO>
		<RTRUE>)
	       (ELSE <TELL
"You have nothing to shoot the " D ,PRSO " with." CR>)>>

<ROUTINE DONT-HAVE (OBJ)
	 <TELL "You don't have the " D .OBJ "." CR>>

<ROUTINE V-ZAP ()
	 <COND (<NOT <IN? ,PRSO ,WINNER>>
		<DONT-HAVE ,PRSO>)
	       (<NOT <FSET? ,PRSO ,WEAPONBIT>>
		<TELL "You can't use a " D ,PRSO " as a ray gun!" CR>)
	       (<NOT ,PRSI> <TELL "At what?" CR>)
	       (ELSE <TELL "Nothing happens." CR>)>>

<ROUTINE V-SZAP ()
	 <TELL "ZAPPP!!" CR>>

<ROUTINE PRE-GIVE ()
	 <COND (<NOT <HELD? ,PRSO>>
		<TELL 
"That's easy for you to say since you don't even have it." CR>)>>

<ROUTINE PRE-SGIVE ()
	 <PERFORM ,V?GIVE ,PRSI ,PRSO>
	 <RTRUE>>

<ROUTINE V-GIVE ()
	 <COND (<NOT <FSET? ,PRSI ,VICBIT>>
		<TELL "You can't give a " D ,PRSO " to a " D ,PRSI "!" CR>)
	       (<IDROP> <TELL "Given." CR>)>>

<ROUTINE V-SGIVE ()
	 <TELL "FOOOO!!" CR>>

<ROUTINE V-DROP () <COND (<IDROP> <TELL "Dropped." CR>)>>

<ROUTINE V-THROW () <COND (<IDROP> <TELL "Thrown." CR>)>>

<ROUTINE IDROP ()
	 <COND (<NOT <HELD? ,PRSO>>
		<TELL "You're not carrying the " D ,PRSO "." CR>
		<RFALSE>)
	       (<AND <NOT <IN? ,PRSO ,WINNER>>
		     <NOT <FSET? <LOC ,PRSO> ,OPENBIT>>>
		<TELL "The " D ,PRSO " is closed." CR>
		<RFALSE>)
	       (T <MOVE ,PRSO <LOC ,WINNER>> <RTRUE>)>>

\

<ROUTINE ALREADY (ON-OFF "OPTIONAL" (OBJ <>))
	 <COND (.OBJ
		<TELL "The " D .OBJ " is ">)
	       (ELSE
		<TELL "It's ">)>
	 <TELL "already " .ON-OFF "." CR>>

<ROUTINE V-OPEN ("AUX" F STR)
	 <COND (<NOT <FSET? ,PRSO ,CONTBIT>>
		<TELL
"You must be very clever to do that to the " D ,PRSO "." CR>)
	       (<OR <FSET? ,PRSO ,DOORBIT>
		    <NOT <==? <GETP ,PRSO ,P?CAPACITY> 0>>>
		<COND (<FSET? ,PRSO ,OPENBIT> <ALREADY "open">)
		      (T
		       <FSET ,PRSO ,OPENBIT>
		       <COND (<FSET? ,PRSO ,DOORBIT>
			      <TELL "The " D ,PRSO " is now open." CR>)
			     (<OR <NOT <FIRST? ,PRSO>> <FSET? ,PRSO ,TRANSBIT>>
			      <TELL "Opened." CR>)
			     (<AND <SET F <FIRST? ,PRSO>>
				   <NOT <NEXT? .F>>
				   <SET STR <GETP .F ,P?FDESC>>>
			      <TELL "The " D ,PRSO " opens." CR>
			      <TELL .STR CR>)
			     (T
			      <TELL "Opening the " D ,PRSO " reveals ">
			      <PRINT-CONTENTS ,PRSO>
			      <TELL "." CR>)>)>)
	       (T <TELL "The " D ,PRSO " cannot be opened." CR>)>>

<ROUTINE PRINT-CONTENTS (OBJ "AUX" F N (1ST? T))
	 #DECL ((OBJ) OBJECT (F N) <OR FALSE OBJECT>)
	 <COND (<SET F <FIRST? .OBJ>>
		<REPEAT ()
			<SET N <NEXT? .F>>
			<COND (.1ST? <SET 1ST? <>>)
			      (ELSE
			       <TELL ", ">
			       <COND (<NOT .N> <TELL "and ">)>)>
			<TELL "a " D .F>
			<SET F .N>
			<COND (<NOT .F> <RETURN>)>>)>>

<ROUTINE V-CLOSE ()
	 <COND (<NOT <FSET? ,PRSO ,CONTBIT>>
		<TELL "You must tell me how to do that to a " D ,PRSO "." CR>)
	       (<AND <NOT <FSET? ,PRSO ,SURFACEBIT>>
		     <OR <NOT <==? <GETP ,PRSO ,P?CAPACITY> 0>>
			 <FSET? ,PRSO ,DOORBIT>>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <FCLEAR ,PRSO ,OPENBIT>
		       <TELL "Closed." CR>)
		      (T <ALREADY "closed">)>)
	       (ELSE
		<TELL "You cannot close that." CR>)>>

<ROUTINE CCOUNT (OBJ "AUX" (CNT 0) X)
	 <COND (<SET X <FIRST? .OBJ>>
		<REPEAT ()
			<SET CNT <+ .CNT 1>>
			<COND (<NOT <SET X <NEXT? .X>>>
			       <RETURN>)>>)>
	 .CNT>

"WEIGHT:  Get sum of SIZEs of supplied object, recursing to the nth level."

<ROUTINE WEIGHT
	 (OBJ "AUX" CONT (WT 0))
	 #DECL ((OBJ) OBJECT (CONT) <OR FALSE OBJECT> (WT) FIX)
	 <COND (<SET CONT <FIRST? .OBJ>>
		<REPEAT ()
			<SET WT <+ .WT <WEIGHT .CONT>>>
			<COND (<NOT <SET CONT <NEXT? .CONT>>> <RETURN>)>>)>
	 <+ .WT <GETP .OBJ ,P?SIZE>>>

<ROUTINE V-SCRIPT ()
	 <PUT 0 8 <BOR <GET 0 8> 1>>
	 <TELL "Ok." CR>>

<ROUTINE V-UNSCRIPT ()
	 <PUT 0 8 <BAND <GET 0 8> -2>>
	 <TELL "Ok." CR>>

<ROUTINE PRE-MOVE
	 ()
	 <COND (<HELD? ,PRSO> <TELL "I don't juggle objects!" CR>)>>

<ROUTINE V-MOVE ()
	 <COND (<FSET? ,PRSO ,TAKEBIT>
		<TELL "Moving the " D ,PRSO " reveals nothing." CR>)
	       (T <TELL "You can't move the " D ,PRSO "." CR>)>>

<ROUTINE V-LAMP-ON
	 ()
	 <COND (<FSET? ,PRSO ,LIGHTBIT>
		<COND (<FSET? ,PRSO ,ONBIT> <ALREADY "on">)
		      (ELSE
		       <FSET ,PRSO ,ONBIT>
		       <TELL "The " D ,PRSO " is now on." CR>
		       <COND (<NOT ,LIT>
			      <SETG LIT <LIT? ,HERE>>
			      <V-LOOK>)>)>)
	       (T
		<TELL "You can't turn that on." CR>)>
	 <RTRUE>>

<ROUTINE V-LAMP-OFF
	 ()
	 <COND (<FSET? ,PRSO ,LIGHTBIT>
		<COND (<NOT <FSET? ,PRSO ,ONBIT>>
		       <ALREADY "off">)
		      (ELSE
		       <FCLEAR ,PRSO ,ONBIT>
		       <COND (,LIT
			      <SETG LIT <LIT? ,HERE>>)>
		       <TELL "The " D ,PRSO " is now off." CR>
		       <COND (<NOT <SETG LIT <LIT? ,HERE>>>
			      <TELL "It is now pitch black." CR>)>)>)
	       (ELSE <TELL "You can't turn that off." CR>)>
	 <RTRUE>>

<ROUTINE V-WAIT ("OPTIONAL" (NUM 3))
	 #DECL ((NUM) FIX)
	 <TELL "Time passes..." CR>
	 <REPEAT ()
		 <COND (<L? <SET NUM <- .NUM 1>> 0> <RETURN>)
		       (<CLOCKER> <RETURN>)>
		 <SETG MOVES <+ ,MOVES 1>>>
	 <SETG CLOCK-WAIT T>>

<ROUTINE PRE-BOARD ("AUX" AV)
	 <SET AV <LOC ,WINNER>>
	 <COND (<FSET? ,PRSO ,VEHBIT>
		<COND ;(<NOT <HERE?? ,PRSO>>
		       <TELL "The "
			     D
			     ,PRSO
			     " must be on the ground to be boarded." CR>)
		      (<FSET? .AV ,VEHBIT>
		       <TELL "You are already in it!" CR>)
		      (T <RFALSE>)>)
	       (<EQUAL? ,PRSO ,SPACESUIT ,JUNK-SPACESUIT>
		<RFALSE>)
	       (T
		<TELL "I suppose you have a theory on boarding a "
		      D
		      ,PRSO
		      "." CR>)>
	 <RFATAL>>

<ROUTINE V-BOARD ("AUX" AV)
	 #DECL ((AV) OBJECT)
	 <TELL "You are now in the " D ,PRSO "." CR>
	 <MOVE ,WINNER ,PRSO>
	 <APPLY <GETP ,PRSO ,P?ACTION> ,M-ENTER>
	 <RTRUE>>

<ROUTINE V-DISEMBARK
	 ()
	 <COND (<NOT <==? <LOC ,WINNER> ,PRSO>>
		<TELL "You're not in that!" CR>
		<RFATAL>)
	       (T
		<TELL "You are on your own feet again." CR>
		<MOVE ,WINNER ,HERE>)>>

<ROUTINE GOTO (RM "OPTIONAL" (V? T) "AUX" (WLOC <LOC ,WINNER>) OLIT)
	 #DECL ((RM WLOC) OBJECT)
	 <SET OLIT ,LIT>
	 <MOVE ,WINNER .RM>
	 <SETG MFOLLOW <>> ;"we moved, so can't follow him"
	 <SETG CHFOLLOW <>> ;"ditto"
	 <SETG HERE .RM>
	 <SETG LIT <LIT? ,HERE>>
	 <COND (<AND <NOT .OLIT>
		     <NOT ,LIT>
		     <PROB 75>>
		<JIGS-UP
"Oh, no! A lurking grue slithered into the room and devoured you!">
		<RTRUE>)>
	 <COND (<==? <APPLY <GETP ,HERE ,P?ACTION> ,M-ENTER> 2>
		<RTRUE>)>
	 <COND (<NOT <==? ,ADVENTURER ,WINNER>>
		<TELL "The " D ,WINNER " leaves the room." CR>)
	       (.V? <V-FIRST-LOOK>)>
	 <SCORE-OBJ .RM>
	 <RTRUE>>

<ROUTINE V-BACK
	 ()
	 <TELL
"Sorry, my memory isn't that good. You'll have to give a direction." CR>>

<ROUTINE V-DRINK ()
	 <V-EAT>>

<ROUTINE V-EAT ()
	 <TELL "I don't think that the "
		      D
		      ,PRSO
		      " would agree with you." CR>>

<ROUTINE V-CURSES ()
	 <COND (,PRSO
		<COND (<FSET? ,PRSO ,VILLAIN>
		       <TELL "Insults of this nature won't help you." CR>)
		      (T
		       <TELL "What a loony!" CR>)>)
	       (T
		<TELL
"Such language in a high-class establishment like this!" CR>)>>

<ROUTINE V-LISTEN ()
	 <TELL "The " D ,PRSO " makes no sound." CR>>

<ROUTINE V-FOLLOW ()
	 <TELL "You're nuts!" CR>>

<ROUTINE V-LEAP ("AUX" T S)
	 #DECL ((T) <OR FALSE TABLE>)
	 <COND (,PRSO
		<COND (<IN? ,PRSO ,HERE>
		       <COND (<FSET? ,PRSO ,VILLAIN>
			      <TELL "The "
				    D
				    ,PRSO
				    " is too big to jump over." CR>)
			     (T <V-SKIP>)>)
		      (T <TELL "That would be a good trick." CR>)>)
	       (<SET T <GETPT ,HERE ,P?DOWN>>
		<SET S <PTSIZE .T>>
		<COND (<OR <==? .S 2>					 ;NEXIT
			   <AND <==? .S 4>				 ;CEXIT
				<NOT <VALUE <GETB .T 1>>>>>
		       <TELL
"This was not a very safe place to try jumping." CR>
		       <JIGS-UP "You should have looked before you leaped.">)
		      (T <V-SKIP>)>)
	       (ELSE <V-SKIP>)>>

<ROUTINE V-SKIP () <TELL <PICK-ONE ,WHEEEEE> CR>>

<ROUTINE V-LEAVE () <DO-WALK ,P?OUT>>

<GLOBAL HS 0>

<ROUTINE V-HELLO ()
	 <COND (,PRSO
		<TELL
"I think that only schizophrenics say \"Hello\" to a " D ,PRSO "." CR>)
	       (ELSE <TELL <PICK-ONE ,HELLOS> CR>)>>

<GLOBAL HELLOS
	<LTABLE "Hello."
	        "Nice weather we've been having lately."
	        "Goodbye.">>

<GLOBAL WHEEEEE
	<LTABLE "Have you tried skipping from star to star, too?"
	        "Are you enjoying yourself?"
	        "Wheeeeeeeeee!!!!!">>

<ROUTINE PRE-READ ()
	 ;<COND (<NOT ,LIT> <TELL "It is impossible to read in the dark." CR>)
	       (<AND ,PRSI <NOT <FSET? ,PRSI ,TRANSBIT>>>
		<TELL "How does one look through a " D ,PRSI "?" CR>)>
	 <RFALSE>>

<ROUTINE V-READ ()
	 <COND (<NOT <FSET? ,PRSO ,READBIT>>
		<TELL "How can I read a " D ,PRSO "?" CR>)
	       (ELSE <TELL <GETP ,PRSO ,P?TEXT> CR>)>>

<ROUTINE V-LOOK-UNDER () <TELL "There is nothing but dust there." CR>>

<ROUTINE V-LOOK-BEHIND () <V-LOOK-UNDER>>

<ROUTINE V-LOOK-INSIDE
	 ()
	 <COND (<FSET? ,PRSO ,DOORBIT>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <TELL "The "
			     D
			     ,PRSO
			     " is open, but I can't tell what's beyond it.">)
		      (ELSE <TELL "The " D ,PRSO " is closed.">)>
		<CRLF>)
	       (<FSET? ,PRSO ,CONTBIT>
		<COND (<FSET? ,PRSO ,VICBIT>
		       <TELL "There is nothing special to be seen." CR>)
		      (<SEE-INSIDE? ,PRSO>
		       <COND (<AND <FIRST? ,PRSO> <PRINT-CONT ,PRSO>>
			      <RTRUE>)
			     (<FSET? ,PRSO ,SURFACEBIT>
			      <TELL "There is nothing on the " D ,PRSO "." CR>)
			     (T
			      <TELL "The " D ,PRSO " is empty." CR>)>)
		      (ELSE <TELL "The " D ,PRSO " is closed." CR>)>)
	       (<FSET? ,PRSO ,TRANSBIT>
		<TELL "You can see dimly through the " D ,PRSO "." CR>)
	       (ELSE <TELL "I don't know how to look inside a " D ,PRSO "." CR>)>>

<ROUTINE SEE-INSIDE? (OBJ)
	 <AND <NOT <FSET? .OBJ ,INVISIBLE>>
	      <OR <FSET? .OBJ ,TRANSBIT> <FSET? .OBJ ,OPENBIT>>>>

<ROUTINE PRE-TURN
	 ()
	 <COND (<NOT <FSET? ,PRSO ,TURNBIT>> <TELL "You can't turn that!" CR>)
	       (<NOT <FSET? ,PRSI ,TOOLBIT>>
		<TELL "You certainly can't turn it with a " D ,PRSI "." CR>)>>

<ROUTINE V-TURN () <TELL "That doesn't work." CR>>

<ROUTINE V-LOCK () <V-TURN>>

<ROUTINE V-PICK () <V-TURN>>

<ROUTINE V-UNLOCK () <V-TURN>>

<ROUTINE V-KILL ()
	 <IKILL "kill">>

<ROUTINE IKILL (STR)
	 #DECL ((STR) STRING)
	 <COND (<NOT ,PRSO> <TELL "There is nothing here to " .STR "." CR>)
	       (<AND <NOT <FSET? ,PRSO ,VILLAIN>>
		     <NOT <FSET? ,PRSO ,VICBIT>>>
		<TELL "I've known strange people, but fighting a "
		      D
		      ,PRSO
		      "?" CR>)
	       (<OR <NOT ,PRSI> <==? ,PRSI ,HANDS>>
		<FUTILE .STR>)
	       (<NOT <FSET? ,PRSI ,WEAPONBIT>>
		<TELL "Trying to "
		      .STR
		      " the "
		      D
		      ,PRSO
		      " with a "
		      D
		      ,PRSI
		      " is futile." CR>)
	       (ELSE <TELL "You can't." CR>)>>

<ROUTINE V-ATTACK () <IKILL "attack">>

<ROUTINE V-KICK () <HACK-HACK "Kicking the ">>

<ROUTINE V-WAVE () <HACK-HACK "Waving the ">>

<ROUTINE V-RAISE () <HACK-HACK "Playing in this way with the ">>

<ROUTINE V-LOWER () <HACK-HACK "Playing in this way with the ">>

<ROUTINE V-RUB () <HACK-HACK "Fiddling with the ">>

<ROUTINE V-PUSH () <HACK-HACK "Pushing the ">>

<ROUTINE PRE-MUNG ()
	 <COND (<NOT <FSET? ,PRSO ,VICBIT>>
		<HACK-HACK "Trying to destroy the ">)
	       (<NOT ,PRSI>
		<FUTILE "destroy">)>>

<ROUTINE FUTILE (STR)
	 <TELL
"Trying to " .STR " a " D ,PRSO " with your bare hands is futile." CR>>

<ROUTINE V-MUNG ()
	 <COND (<FSET? ,PRSO ,KEYBIT>
		<REMOVE ,PRSO>
		<TELL
"It shatters and disappears." CR>)
	       (T <TELL "You can't." CR>)>>

<ROUTINE HACK-HACK
	 (STR)
	 #DECL ((STR) STRING)
	 <TELL .STR D ,PRSO <PICK-ONE ,HO-HUM> CR>>

<GLOBAL HO-HUM
	<LTABLE
	 " isn't notably helpful."
	 " does nothing."
	 " has no effect.">>

<ROUTINE WORD-TYPE
	 (OBJ WORD "AUX" SYNS)
	 #DECL ((OBJ) OBJECT (WORD SYNS) TABLE)
	 <ZMEMQ .WORD
		<SET SYNS <GETPT .OBJ ,P?SYNONYM>>
		<- </ <PTSIZE .SYNS> 2> 1>>>

<ROUTINE V-KNOCK
	 ()
	 <COND (<WORD-TYPE ,PRSO ,W?DOOR>
		<TELL "Nobody's home." CR>)
	       (ELSE <TELL "Why knock on a " D ,PRSO "?" CR>)>>

<ROUTINE V-FROBOZZ
	 ()
	 <TELL
"The FROBOZZ Corporation sponsored this expedition." CR>>

<ROUTINE V-YELL () <TELL "Aarrrrggggggghhhhhhhh!" CR>>

<ROUTINE V-PLUG () <TELL "This has no effect." CR>>

\

<ROUTINE V-SHAKE ("AUX" X)
	 <COND (<FSET? ,PRSO ,VILLAIN>
		<TELL "This seems to have no effect." CR>)
	       (<AND <NOT <FSET? ,PRSO ,OPENBIT>>
		     <FIRST? ,PRSO>>
		<TELL "It sounds like there is something inside the "
		      D
		      ,PRSO
		      "."
		      CR>)
	 (<AND <FSET? ,PRSO ,OPENBIT> <FIRST? ,PRSO>>
	  <REPEAT ()
		  <COND (<SET X <FIRST? ,PRSO>> <MOVE .X ,PRSO>)
			(ELSE <RETURN>)>>
	  <TELL "All of the objects spill onto the floor." CR>)>>

<ROUTINE V-DIG () <TELL "What a silly idea!" CR>>

<ROUTINE V-SMELL ()
	 <COND (,SUIT-ON?
		<SETG PRSO ,SPACESUIT>)>
	 <TELL "It smells just like a " D ,PRSO "." CR>>

<ROUTINE GLOBAL-IN? (OBJ1 OBJ2 "AUX" T)
	 #DECL ((OBJ1 OBJ2) OBJECT (T) <OR FALSE TABLE>)
	 <COND (<SET T <GETPT .OBJ2 ,P?GLOBAL>>
		<ZMEMQB .OBJ1 .T <- <PTSIZE .T> 1>>)>>

<ROUTINE HERE?? (OBJ)
	 <OR <IN? .OBJ ,HERE> <GLOBAL-IN? .OBJ ,HERE>>>

<ROUTINE V-SWIM ()
	 <COND (<FSET? ,HERE ,RAIRBIT>
		<TELL
"Waving your arms and legs about doesn't help much. You move a little, but
some stronger impulse would be much more useful." CR>)
	       (ELSE
		<TELL "You can't swim here!" CR>)>>

<ROUTINE V-UNTIE () <TELL "Unfasten it how?" CR>>

<ROUTINE PRE-TIE
	 ()
	 <COND (<==? ,PRSI ,WINNER>
		<TELL "You can't tie it to yourself." CR>)>>

<ROUTINE V-TIE () <TELL "You can't tie the " D ,PRSO " to that." CR>>

<ROUTINE V-ALARM ()
	 <COND (<FSET? ,PRSO ,VILLAIN>
		<TELL "He's wide awake, or haven't you noticed..." CR>)
	       (ELSE
		<TELL "The " D ,PRSO " isn't sleeping." CR>)>>

<ROUTINE V-ZORK () <TELL "I see no Zork here." CR>>

\

<ROUTINE V-COMMAND ()
	 <COND (<FSET? ,PRSO ,VICBIT>
		<TELL "The " D ,PRSO " pays no attention." CR>)
	       (ELSE
		<TELL "You cannot talk to that!" CR>)>>

<ROUTINE V-CLIMB-ON ()
	 <COND (<AND <FSET? ,PRSO ,FURNITURE> <FSET? ,PRSO ,VEHBIT>>
		<PERFORM ,V?BOARD ,PRSO>
		<RTRUE>)
	       (<FSET? ,PRSO ,VEHBIT>
		<V-CLIMB-UP ,P?UP T>)
	       (T
		<TELL "You can't climb onto the " D ,PRSO "." CR>)>>

<ROUTINE V-CLIMB-FOO () <V-CLIMB-UP ,P?UP T>>

<ROUTINE V-CLIMB-UP ("OPTIONAL" (DIR ,P?UP) (OBJ <>) "AUX" X)
	 #DECL ((DIR) FIX (OBJ) <OR ATOM FALSE> (X) TABLE)
	 <COND (<GETPT ,HERE .DIR>
		<DO-WALK .DIR>
		<RTRUE>)
	       (<NOT .OBJ>
		<TELL "You can't go that way." CR>)
	       (ELSE <TELL "Bizarre!" CR>)>>

<ROUTINE V-CLIMB-DOWN ()
	 <COND (<AND <FSET? ,PRSO ,FURNITURE> <FSET? ,PRSO ,VEHBIT>>
		<V-CLIMB-ON>
		<RTRUE>)
	       (T <V-CLIMB-UP ,P?DOWN>)>>

<ROUTINE V-PUT-UNDER ()
	 <TELL "You can't do that." CR>>

<ROUTINE V-ENTER ()
	 <DO-WALK ,P?IN>>

<ROUTINE V-EXIT ()
	 <DO-WALK ,P?OUT>>

<ROUTINE V-SEARCH ()
	 <TELL "You find nothing unusual." CR>>

<ROUTINE V-FIND ("AUX" (L <LOC ,PRSO>))
	 <COND (<EQUAL? ,PRSO ,ME ,HANDS>
		<TELL "You're around here somewhere..." CR>)
	       (<EQUAL? .L ,GLOBAL-OBJECTS>
		<TELL "You find it." CR>)
	       (<IN? ,PRSO ,WINNER>
		<TELL "You have it." CR>)
	       (<OR <IN? ,PRSO ,HERE>
		    <==? ,PRSO ,PSEUDO-OBJECT>>
		<TELL "It's right here." CR>)
	       (<FSET? .L ,VILLAIN>
		<TELL "The " D .L " has it." CR>)
	       (<FSET? .L ,CONTBIT>
		<TELL "It's in the " D .L "." CR>)
	       (ELSE
		<TELL "Beats me." CR>)>>

<ROUTINE V-TELL ()
	 <COND (<FSET? ,PRSO ,VICBIT>
		<SETG WINNER ,PRSO>)
	       (T
		<TELL "You can't talk to the " D ,PRSO "!" CR>
		<SETG QUOTE-FLAG <>>
		<SETG P-CONT <>>
		<RFATAL>)>>

<ROUTINE V-ANSWER ()
	 <TELL "Nobody is awaiting your answer." CR>
	 <SETG P-CONT <>>
	 <SETG QUOTE-FLAG <>>
	 <RTRUE>>

<ROUTINE V-REPLY ()
	 <TELL "It is hardly likely that the " D ,PRSO " is interested." CR>
	 <SETG P-CONT <>>
	 <SETG QUOTE-FLAG <>>
	 <RTRUE>>

<ROUTINE V-IS-IN ()
	 <COND (<IN? ,PRSO ,PRSI>
		<TELL "Yes, it is ">
		<COND (<FSET? ,PRSI ,SURFACEBIT>
		       <TELL "on">)
		      (T <TELL "in">)>
		<TELL " the " D ,PRSI "." CR>)
	       (T <TELL "No, it isn't." CR>)>>

<ROUTINE V-KISS ()
	 <TELL "I'd sooner kiss a pig." CR>>

<ROUTINE V-RAPE ()
	 <TELL "What a (ahem!) strange idea." CR>>

<ROUTINE V-DIAGNOSE ()
	 <TELL "You are in perfect health." CR>
	 <COND (<NOT <0? ,DEATHS>>
		<TELL "You have been killed ">
		<COND (<1? ,DEATHS> <TELL "once.">)
		      (<==? ,DEATHS 2> <TELL "twice.">)
		      (T <TELL "three times.">)>
		<CRLF>)>>

<ROUTINE V-SAY ("AUX" V)
	 <COND (<SET V <FIND-IN ,HERE ,VICBIT>>
		<SETG P-CONT <>>
		<TELL "You must address the " D .V " directly." CR>)
	       (ELSE
		<SETG QUOTE-FLAG <>>
		<SETG P-CONT <>>
		<TELL
"Talking to yourself is a sign of impending mental collapse." CR>)>>

<ROUTINE V-WEAR ()
	 <TELL "You can't wear that, and besides, it wouldn't fit." CR>>

<ROUTINE V-REMOVE ()
	 <COND (<FSET? ,PRSO ,WEARBIT> <PERFORM ,V?TAKE-OFF ,PRSO> <RTRUE>)
	       (ELSE <PERFORM ,V?TAKE ,PRSO> <RTRUE>)>>

<ROUTINE V-TAKE-OFF ()
	 <COND (<FSET? ,PRSO ,VEHBIT> <V-DISEMBARK>)
	       (T <TELL "You aren't wearing that." CR>)>>

<ROUTINE V-STEP-ON ()
	 <TELL "That's a silly thing to do." CR>>

<ROUTINE V-PUT-ON ()
	 <PERFORM ,V?PUT ,PRSO ,PRSI>>

<ROUTINE V-LAND ()
	 <TELL "Such complicated tasks are best left to computers." CR>>

<ROUTINE ROB (WHO "OPTIONAL" (WHERE <>) (HIDE? <>) "AUX" N X (ROBBED? <>))
	 <SET X <FIRST? .WHO>>
	 <REPEAT ()
		 <COND (<NOT .X> <RETURN .ROBBED?>)>
		 <SET N <NEXT? .X>>
		 <COND (<RIPOFF .X .WHERE>
			<COND (.HIDE? <FSET .X ,NDESCBIT>)>
			<SET ROBBED? .X>)>
		 <SET X .N>>>

<ROUTINE RIPOFF (X WHERE)
	 <COND (<AND <==? .X ,BLUE-KEY>
		     <IN? ,BLUE-KEY ,FORCE-FIELD-1>>
		<RFALSE>)
	       (<AND <NOT <IN? .X .WHERE>>
		     <NOT <FSET? .X ,INVISIBLE>>
		     <FSET? .X ,TOUCHBIT>
		     <FSET? .X ,TAKEBIT>>
		<COND (<==? .X ,UNDER-GLOBE>
		       <FCLEAR .X ,NDESCBIT>
		       <SETG UNDER-GLOBE <>>)>
		<COND (<EQUAL? .X ,RED-DISK ,BLUE-DISK>
		       <DISK-SWITCH .X <>>)>
		<COND (.WHERE <MOVE .X .WHERE>)
		      (ELSE <REMOVE .X>)>
		<RTRUE>)>>

<ROUTINE V-STAND ()
	 <COND (<FSET? <LOC ,WINNER> ,VEHBIT>
		<PERFORM ,V?DISEMBARK <LOC ,WINNER>>
		<RTRUE>)
	       (ELSE
		<TELL "You are already standing, I think." CR>)>>

<ROUTINE V-NO ()
	 <TELL "You sound rather negative." CR>>

<ROUTINE V-YES ()
	 <TELL "You sound rather positive." CR>>

<ROUTINE V-POINT () <TELL "It's usually impolite to point." CR>>

<ROUTINE V-SET ()
	 <TELL "Setting a " D ,PRSO " is a strange concept." CR>>

<ROUTINE V-PLAY ()
	 <TELL "Playing a " D ,PRSO "?" CR>>

<ROUTINE V-$VERIFY ()
	 <TELL "Verifying game..." CR>
	 <COND (<VERIFY> <TELL "Game correct." CR>)
	       (T <TELL CR "** Game File Failure **" CR>)>>

<ROUTINE V-STAND-ON ()
	 <TELL "Standing on a " D ,PRSO " seems like a waste of time." CR>>

<ROUTINE V-REPORT ()
	 <TELL
"Report? Why don't you wait until you've accomplished something..." CR>>

<ROUTINE V-LOOK-SAFELY ()
	 <COND (<FSET? ,PRSI ,TRANSBIT>
		<TELL "The " D ,PRSO " looks as before, only tinged by the
color of the " D ,PRSI "." CR>)
	       (ELSE <TELL "The " D ,PRSI " isn't transparent." CR>)>>

<ROUTINE V-REACH ()
	 <COND (<FIRST? ,PRSO>
		<TELL "There is something">)
	       (ELSE <TELL "There is nothing">)>
	 <TELL " inside the " D ,PRSO "." CR>>

<ROUTINE V-REACH-FOR ()
	 <COND (<FSET? ,PRSO ,TAKEBIT>
		<PERFORM ,V?TAKE ,PRSO>
		<RTRUE>)
	       (<IN? ,PRSO ,HERE>
		<TELL "It's here! Now what?" CR>)
	       (ELSE <TELL "It is out of reach." CR>)>>

<ROUTINE DO-WALK (DIR)
	 <SETG P-WALK-DIR .DIR>
	 <PERFORM ,V?WALK .DIR>>

<ROUTINE V-WALK-TO ()
	 <COND (<OR <IN? ,PRSO ,HERE>
		    <GLOBAL-IN? ,PRSO ,HERE>>
		<TELL "It's here!" CR>)
	       (T <TELL "You should supply a direction!" CR>)>>

<ROUTINE V-FLY ()
	 <TELL "Humans are not usually equipped for flying." CR>>

<ROUTINE V-SMILE ()
	 <TELL "How pleasant!" CR>>
