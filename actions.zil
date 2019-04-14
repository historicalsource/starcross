"ACTIONS for
			   Interlogic SF Game
       (c) Copyright 1981,1982 Infocom, Inc. All Rights Reserved
"

<GLOBAL ALARM? T>

<ROUTINE BRIDGE-FCN (RARG)
	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"This is the control room of the Starcross. There are exits labelled
(arbitrarily) \"Port,\" \"Starboard,\" and \"Out.\" The latter exit has
a heavy bulkhead which is " <COND (<FSET? ,AIRLOCK-INNER ,OPENBIT>
				   "open.")
				  (T "closed.")>>
		<CRLF>
		<TELL
"Your ship's computer does the routine tasks of navigation and life support.
A control couch is mounted before a control panel and a large viewport. The
ship's registration is affixed nearby." CR>
		<TELL
"Your mass detector, essential in the search for black holes, sits to one
side. On the detector are a red button, a blue button, and a small screen
on which something is displayed." CR>)>>

<ROUTINE DETECTOR-FCN ()
	 <COND (<VERB? EXAMINE READ>
		<TELL "The display reads: \"">
		<PRINTD ,MASS>
		<TELL ".\"" CR>)>>

<GLOBAL MASS <>>
<GLOBAL MASSNUM <>>

<ROUTINE I-ALARM ("AUX" (HEAR? <>))
	 <COND (,ALARM?
		<COND (<NOT ,MASS>
		       <SETG MASSNUM <RANDOM 8>>
		       <SETG MASS <GET ,MASSES ,MASSNUM>>)>
		<ENABLE <QUEUE I-ALARM 1>>
		<COND (<EQUAL? ,HERE ,SPACESHIP-BRIDGE
			       ,SPACESHIP-QUARTERS ,SPACESHIP-STORES>
		       <SET HEAR? T>)
		      (<AND <==? ,HERE ,SPACESHIP-AIRLOCK>
			    <FSET? ,AIRLOCK-INNER ,OPENBIT>>
		       <SET HEAR? T>)>
		<COND (.HEAR?
		       <TELL
"The alarm bell on the mass detector is ringing stridently." CR>)>
		<COND (<==? ,MOVES 15>
		       <SETG ALARM? <>>
		       <SETG COMPUTER-ON T>
		       <COND (.HEAR?
			      <TELL
"\"If you won't turn it off, I will. I can't take the noise any more.\"" CR>)>)
		      (<AND .HEAR? <==? ,MOVES 10>>
		       <SETG COMPUTER-ON T>
		       <TELL
"An expressionless but nonetheless surly voice issues from the computer:
\"Please turn that alarm off! We'll both have headaches if you don't.\"" CR>)>
		<RTRUE>)>>

<ROUTINE ALARM-FCN ()
	 <COND (<VERB? LISTEN>
		<TELL "The alarm is ">
		<COND (,ALARM? <TELL "ringing.">)(T <TELL "off.">)>
		<CRLF>)
	       (<NOT <==? ,HERE ,SPACESHIP-BRIDGE>>
		<TELL "The alarm is on the bridge, not here." CR>)
	       (<VERB? EXAMINE>
		<TELL "The alarm is ">
		<COND (,ALARM? <TELL "ringing.">)(T <TELL "off.">)>
		<CRLF>)
	       (<VERB? LAMP-OFF PUSH>
		<COND (,ALARM?
		       <SETG ALARM? <>>
		       <TELL
"The alarm goes silent." CR>)
		      (T
		       <TELL
"The alarm's already off. Your ears must be ringing." CR>)>)
	       (<VERB? LAMP-ON>
		<TELL
"Only the mass detector can turn the alarm on." CR>)>>

<ROUTINE MASS-FCN ()
	 <COND (<VERB? SET>
		<COND (<KVETCH> <RTRUE>)
		      (ELSE
		       <TELL
"The computer must be used to set courses, as navigation is fully
automated." CR>)>)
	       (<VERB? EXAMINE>
		<COND (<HELD? ,CHART>
		       <TELL
"It's still here on the output." CR>)
		      (ELSE <TELL "You don't have the output." CR>)>)>>

<ROUTINE BUNK-FCN ("OPTIONAL" (RARG <>))
	 <COND (<AND <==? .RARG ,M-BEG>
		     <VERB? WALK>
		     <IN? ,ADVENTURER ,BUNK>>
		<TELL "You must get up first!" CR>)>>

<ROUTINE BUTTON-FCN ()
	 <COND (<VERB? PUSH>
		<COND (<FSET? ,CHART ,TOUCHBIT>
		       <TELL "Nothing happens." CR>)
		      (T
		       <MOVE ,CHART ,HERE>
		       <FSET ,CHART ,TOUCHBIT>
		       <TELL
"The mass detector produces some output." CR>)>)>>

<ROUTINE V-R ()
	 <COND (<==? ,WINNER ,COMPUTER>
		<COND (<==? ,PRSO ,INTNUM>
		       <COND (<OR <0? ,P-NUMBER> <G? ,P-NUMBER 360>>
			      <NOT-IN-RANGE "R">
			      <RTRUE>)
			     (T <OK-TELL ,R-VALUE "R">)>
		       <SETG R-VALUE ,P-NUMBER>
		       <COURSE-SET>)
		      (T <NON-NUMERIC "R">)>)
	       (ELSE
		<EXPLAIN-COORDINATES>)>>

<ROUTINE V-THETA ()
	 <COND (<==? ,WINNER ,COMPUTER>
		<COND (<==? ,PRSO ,INTNUM>
		       <COND (<OR <0? ,P-NUMBER> <G? ,P-NUMBER 360>>
			      <NOT-IN-RANGE "theta">
			      <RTRUE>)
			     (T <OK-TELL ,THETA-VALUE "Theta">)>
		       <SETG THETA-VALUE ,P-NUMBER>
		       <COURSE-SET>)
		      (T <NON-NUMERIC "theta">)>)
	       (ELSE <EXPLAIN-COORDINATES>)>>

<ROUTINE V-PHI ()
	 <COND (<==? ,WINNER ,COMPUTER>
		<COND (<==? ,PRSO ,INTNUM>
		       <COND (<OR <0? ,P-NUMBER> <G? ,P-NUMBER 360>>
			      <NOT-IN-RANGE "phi">
			      <RTRUE>)
			     (T <OK-TELL ,PHI-VALUE "Phi">)>
		       <SETG PHI-VALUE ,P-NUMBER>
		       <COURSE-SET>)
		      (T <NON-NUMERIC "phi">)>)
	       (ELSE <EXPLAIN-COORDINATES>)>>

<ROUTINE OK-TELL (VAL STR)
	 <TELL "\"">
	 <COND (.VAL
		<TELL "Changing your mind, eh? ">)>
	 <TELL .STR " set.">>

<ROUTINE NOT-IN-RANGE (STR)
	 <TELL
"\"That value for " .STR " is out of range.\"" CR>>

<ROUTINE NON-NUMERIC (STR)
	 <TELL
"\"You must give me a numerical value for " .STR ".\"" CR>>

<ROUTINE EXPLAIN-COORDINATES ()
	 <COND (<KVETCH> <RTRUE>)
	       (ELSE
		<TELL
"Set a course by telling the computer the R, theta, and phi values of
your destination." CR>)>>

<ROUTINE KVETCH ()
	 <SETG COMPUTER-COUNT <+ ,COMPUTER-COUNT 1>>
	 <COND (<==? ,COMPUTER-COUNT 3>
		<SETG COMPUTER-COUNT 0>
		<TELL
"Please consult the manual for the proper computer operating procedure." CR>)>>

<GLOBAL R-VALUE <>>
<GLOBAL THETA-VALUE <>>
<GLOBAL PHI-VALUE <>>

<GLOBAL COMPUTER-COUNT 0>

<ROUTINE COURSE-SET ()
	 <COND (<AND ,R-VALUE ,THETA-VALUE ,PHI-VALUE>
		<SETG GOT-INSTRUCTIONS T>
		<SETG DESTINATION <>>
		<SETG LOST <>>
		<TELL
"\" Lights blink furiously for a moment. The computer speaks: ">
		<SETG GIVE-UP <FIND-DESTINATION ,KNOWN-LOCS ,KNOWNS>>
		<COND (,GIVE-UP
		       <TELL
"\"Navigational program for " D ,GIVE-UP " is ready. Giving up,
huh? Figures, just when we get a good strike. ">)
		      (<AND <SETG DESTINATION
				  <FIND-DESTINATION ,MASS-LOCS ,MASSES>>
			    <==? ,DESTINATION ,MASS>>
		       <TELL
"\"Sequence for intercept of mass concentration is programmed and ready. ">)
		      (ELSE
		       <SETG LOST T>
		       <TELL
"\"I know my instruments aren't as good as the mass detector, but I see
nothing at that location. Well, if you say so. ">)>
	       <TELL "Please confirm new navigational
program. I'm waiting...\"" CR>)
	 (T <TELL " Waiting for additional values.\"" CR>)>>

<GLOBAL GIVE-UP <>>
<GLOBAL LOST <>>
<GLOBAL DESTINATION <>>
<GLOBAL GOT-INSTRUCTIONS <>>
<GLOBAL COUNTDOWN <>>

<ROUTINE FIND-DESTINATION (X M "AUX" (C 0) (N <GET .X 0>))
	 <REPEAT ()
		 <SET C <+ .C 1>>
		 <COND (<AND <==? <GET .X 1> ,R-VALUE>
			     <==? <GET .X 2> ,THETA-VALUE>
			     <==? <GET .X 3> ,PHI-VALUE>>
			<RETURN <GET .M .C>>)>
		 <COND (<==? .C .N> <RETURN <>>)>
		 <SET X <REST .X 6>>>>

<ROUTINE KNOWN-COURSE (D SET? "AUX" X N (C 0))
	 <SET X ,KNOWN-LOCS>
	 <SET N <GET .X 0>>
	 <REPEAT ()
		 <SET C <+ .C 1>>
		 <COND (<==? <GET ,KNOWNS .C> .D>
			<COND (.SET?
			       <SETG R-VALUE <GET .X 1>>
			       <SETG THETA-VALUE <GET .X 2>>
			       <SETG PHI-VALUE <GET .X 3>>
			       <RETURN .D>)
			      (ELSE <RETURN .X>)>)>
		 <COND (<==? .C .N> <RETURN <>>)>
		 <SET X <REST .X 6>>>>

;<ROUTINE V-CHEAT ("AUX" (N <+ 1 <* 3 <- ,MASSNUM 1>>>))
	 <COND (,MASS
		<REPORT-LOCATION ,MASS ,MASS-LOCS .N>)
	       (ELSE <TELL "Now, now, don't anticipate..." CR>)>>

<ROUTINE REPORT-LOCATION (M ML N)
	 <TELL "\"Coordinates for " D .M
	       ": R is " N <GET .ML .N>
	       ", theta is " N <GET .ML <+ .N 1>>
	       ", phi is " N <GET .ML <+ .N 2>>
	       ".\""
	       CR>>

<ROUTINE CONTROLS-FCN ()
	 <COND (<==? ,HERE ,THRONE-ROOM>
		<COND (<VERB? EXAMINE> <AS-ADVERTISED>)
		      (T <TELL
"The controls look in no way operational." CR>)>)
	       (<VERB? EXAMINE>
		<TELL
"This is a standard control panel for this class of single-passenger mining
ship. Most controls are for emergencies only, as the Starcross is normally
controlled by verbal instructions to the computer.">
		<COND (<NOT <IN? ,COMPUTER ,HERE>>
		       <TELL " This set of controls is non-functional.">)>
		<CRLF>
		<RTRUE>)
	       (<VERB? RUB SET LAMP-ON LAMP-OFF PLAY>
		<COND (<NOT <IN? ,COMPUTER ,HERE>>
		       <TELL
"The controls are no longer functional." CR>)
		      (,COMPUTER-ON
		       <COND (,GOT-INSTRUCTIONS
			      <TELL
"As you reach for the controls, the computer blares: \"Warning! Warning!
Course is set! Remember what happened last time you played with the controls
in mid-course...\"" CR>)
			     (ELSE
			      <TELL
"The computer's voice intrudes. \"Do you really want to touch the controls
just now? Not to impugn your piloting ability, but shouldn't I execute any
course corrections? I'm very good at it, you know.\"" CR>)>)
		      (ELSE
		       <SETG COMPUTER-ON T>
		       <TELL
"The computer comes on and chides, \"Manual operation when the ship's
computer is functional is not recommended. Ship's controls are not
currently enabled.\"" CR>)>)>>

<ROUTINE BRIDGE-EXITS ()
	 <COND (<==? ,PRSO ,P?WEST> ,SPACESHIP-QUARTERS)
	       (<==? ,PRSO ,P?EAST> ,SPACESHIP-STORES)
	       (<EQUAL? ,PRSO ,P?OUT ,P?SOUTH>
		<COND (<FSET? ,AIRLOCK-INNER ,OPENBIT> ,SPACESHIP-AIRLOCK)
		      (T <ITS-CLOSED ,AIRLOCK-INNER>)>)>>

<ROUTINE OPEN-CLOSE (OBJ STROPN STRCLS)
	 <COND (<VERB? OPEN>
		<COND (<FSET? .OBJ ,OPENBIT>
		       <TELL <PICK-ONE ,DUMMY>>)
		      (ELSE
		       <TELL .STROPN>
		       <FSET .OBJ ,OPENBIT>)>
		<CRLF>)
	       (<VERB? CLOSE>
		<COND (<FSET? .OBJ ,OPENBIT>
		       <TELL .STRCLS>
		       <FCLEAR .OBJ ,OPENBIT>
		       T)
		      (ELSE <TELL <PICK-ONE ,DUMMY> CR>)>
		<CRLF>)>>

<GLOBAL DUMMY
	<LTABLE "Look around."
		"You think it isn't?"
		"I think you've already done that.">>

<ROUTINE OBJECT-PSEUDO ()
	 <COND (<VERB? EXAMINE>
		<PERFORM ,V?LOOK-INSIDE ,WINDOW>
		<RTRUE>)>>

<ROUTINE PORTHOLE-FCN ()
	 <COND (<VERB? THROUGH>
		<TELL "There is glass in that porthole, dummy!" CR>)
	       (<VERB? LOOK-INSIDE EXAMINE>
		<COND (<==? ,HERE ,SPACESHIP-BRIDGE>
		       <DESCRIBE-SPACE>)
		      (<==? ,HERE ,THRONE-ROOM>
		       <TELL
"You see the green dock, and the stars wheeling by above." CR>)>)>>

<ROUTINE V-THROUGH ("OPTIONAL" (OBJ <>) "AUX" M)
	#DECL ((OBJ) <OR OBJECT FALSE> (M) <PRIMTYPE VECTOR>)
	<COND (<AND <NOT .OBJ> <FSET? ,PRSO ,VEHBIT>>
	       <PERFORM ,V?BOARD ,PRSO>
	       <RTRUE>)
	      (<AND <NOT .OBJ> <NOT <FSET? ,PRSO ,TAKEBIT>>>
	       <TELL "You hit your head against the "
			    D ,PRSO
			    " as you attempt this feat." CR>)
	      (.OBJ <TELL "You can't do that!" CR>)
	      (<IN? ,PRSO ,WINNER>
	       <TELL "That would involve quite a contortion!" CR>)
	      (ELSE <TELL <PICK-ONE ,YUKS> CR>)>>

<ROUTINE ROOM? (OBJ "AUX" NOBJ)
	 <REPEAT ()
		 <SET NOBJ <LOC .OBJ>>
		 <COND (<NOT .NOBJ> <RFALSE>)
		       (<==? .NOBJ ,WINNER> <RFALSE>)
		       (<==? .NOBJ ,ROOMS> <RETURN .OBJ>)>
		 <SET OBJ .NOBJ>>>

<ROUTINE GRUE-FUNCTION ()
    <COND (<VERB? EXAMINE>
	   <TELL
"The grue is a sinister, lurking presence in the dark places of the
earth. Its favorite diet is spacers, but its insatiable appetite is
tempered by its fear of light. No grue has ever been seen by the light
of day, and few have survived its fearsome jaws to tell the tale." CR>)
	  (<VERB? FIND>
	   <TELL
"There is no grue here, but I'm sure there is at least one lurking
in the darkness nearby. I'd stay in lighted areas if I were you!" CR>)
	  (<VERB? LISTEN>
	   <TELL
"It makes no sound but is always lurking in the darkness nearby." CR>)>>

<ROUTINE GROUND-FCN ()
	 <COND (<AND <VERB? PUT> <==? ,PRSI ,GROUND>>
		<PERFORM ,V?DROP ,PRSO>
		<RTRUE>)
	       (<VERB? DIG>
		<TELL "The ground is too hard for digging here." CR>)>>

<ROUTINE DEBRIS-FCN ()
	 <COND (<AND ,DOCKED?
		     ,SEEN-MOUSE?
		     <VERB? TAKE EXAMINE>>
		<TELL
"You should leave debris for the maintenance mice." CR>)>>

<ROUTINE ADVENTURER-FCN ()
	 <COND (<==? ,ADVENTURER ,WINNER>
		<COND (<AND ,THAT-END
			    ,THIS-END
			    <IN? ,SPACESUIT ,WINNER>
			    <VERB? WALK>
			    <NOT <AND <EQUAL? ,HERE ,YELLOW-DOCK>
				      <EQUAL? ,PRSO ,P?WEST>>>
			    <NOT <AND <EQUAL? ,HERE ,YELLOW-DOCK-EDGE>
				      <EQUAL? ,PRSO ,P?EAST>>>
			    <NOT <AND <EQUAL? ,HERE
					      ,SPACESHIP-AIRLOCK>
				      <EQUAL? ,PRSO ,P?SOUTH ,P?OUT P?DOWN>>>
			    <NOT <AND <EQUAL? ,HERE ,DEEP-SPACE>
				      <EQUAL? ,PRSO ,P?IN>>>>
		       <TELL
"The safety line prevents you from leaving, as it is only about
five meters long. You must detach it to leave." CR>)
		      (<AND ,THAT-END
			    <NOT ,THIS-END>
			    <VERB? WALK>
			    <IN? ,SAFETY-LINE ,WINNER>>
		       <MOVE ,SAFETY-LINE ,HERE>
		       <TELL
"You leave the half-secured safety line behind." CR>
		       <>)>)>>

<ROUTINE CRETIN ()
	 <COND (<VERB? GIVE>
		<PERFORM ,V?TAKE ,PRSO>
		<RTRUE>)
	       (<VERB? EAT> <TELL "Auto-cannibalism is not the answer." CR>)
	       (<VERB? KILL MUNG>
		<COND (<==? ,PRSO ,ME>
		       <JIGS-UP
"If you insist...Poof, you're dead!">)
		      (ELSE <TELL "What a silly idea!" CR>)>)
	       (<VERB? TAKE>
		<TELL "How romantic!" CR>)
	       (<VERB? DISEMBARK>
		<TELL "You'll have to do that on your own." CR>)
	       (<VERB? EXAMINE>
		<TELL "That's hard unless your eyes are prehensile."
		      CR>)>>

<ROUTINE FIND-IN (WHERE WHAT "AUX" W)
	 <SET W <FIRST? .WHERE>>
	 <COND (<NOT .W> <RFALSE>)>
	 <REPEAT ()
		 <COND (<FSET? .W .WHAT> <RETURN .W>)
		       (<NOT <SET W <NEXT? .W>>> <RETURN <>>)>>>

<ROUTINE FIND-TARGET (TARGET "AUX" P TX L ROOM)
	 <COND (<IN? .TARGET ,HERE> ,HERE)
	       (ELSE
		<SET P 0>
		<REPEAT ()
			<COND (<0? <SET P <NEXTP ,HERE .P>>>
			       <RETURN <>>)
			      (<NOT <L? .P ,LOW-DIRECTION>>
			       <SET TX <GETPT ,HERE .P>>
			       <SET L <PTSIZE .TX>>
			       <COND (<OR <EQUAL? .L ,UEXIT>
					  <AND <EQUAL? .L ,CEXIT>
					       <VALUE <GETB .TX ,CEXITFLAG>>>
					  <AND <EQUAL? .L ,DEXIT>
					       <FSET? <GETB .TX ,DEXITOBJ>
						      ,OPENBIT>>>
				      <SET ROOM <GETB .TX 0>>
				      <COND (<IN? .TARGET .ROOM>
					     <RETURN .ROOM>)>)>)>>)>>

<GLOBAL COMPUTER-ON T>

<ROUTINE COMPUTER-FCN ("AUX" N)
	 <COND (<==? ,WINNER ,COMPUTER>
		<COND (<NOT ,COMPUTER-ON>
		       <SETG COMPUTER-ON T>
		       <TELL "The computer turns itself on." CR>)>
		<COND (<OR <VERB? WALK-TO>
			   <AND <VERB? SET> <==? ,PRSO ,COURSE>>>
		       <COND (<VERB? WALK-TO> <SETG PRSI ,PRSO>)>
		       <COND (,DOCKED?
			      <TELL ,ROPES-OFF CR>
			      <RTRUE>)
			     (,ORBIT-MATCHED
			      <TELL
"\"We just got here! I think we should look around first!\"" CR>
			      <RTRUE>)
			     (,COUNTDOWN
			      <TELL ,BURN-COMING CR>
			      <RTRUE>)
			     (,COURSE-SELECTED
			      <TELL ,IN-TRANSIT CR>
			      <RTRUE>)>
		       <COND (<KNOWN-COURSE ,PRSI T>
			      <TELL "\"Course being set for " D ,PRSI ".">
			      <COURSE-SET>)
			     (ELSE
			      <TELL
"The computer sounds surly. \"I told you to buy those additional I/O options.
You know as well as I do that I can't talk to that stupid mass detector, so
you'll just have to tell me the coordinates from its output. Maybe next time
you'll listen.\"" CR>)>)
		      (<VERB? R THETA PHI>
		       <COND (<G? ,VIEW-COUNT 0>
			      <TELL
"\"We just got here. You wouldn't be scared, would you?\"" CR>)
			     (<G? ,TRIP-COUNT 0>
			      <TELL ,IN-TRANSIT CR>)
			     (,DOCKED?
			      <TELL ,ROPES-OFF CR>)
			     (,COUNTDOWN
			      <TELL ,BURN-COMING CR>)
			     (T <>)>)
		      (<VERB? NO>
		       <SETG GOT-INSTRUCTIONS <>>
		       <SETG R-VALUE <>>
		       <SETG THETA-VALUE <>>
		       <SETG PHI-VALUE <>>
		       <SETG GIVE-UP <>>
		       <SETG LOST <>>
		       <TELL "\"Okay.\"" CR>)
		      (<VERB? YES>
		       <COND (<AND ,PRSO <NOT <==? ,PRSO ,COURSE>>>
			      <TELL "\"You can't confirm that!\"" CR>)
			     (,GOT-INSTRUCTIONS
			      <SETG GOT-INSTRUCTIONS <>>
			      <SETG COUNTDOWN T>
			      <ENABLE <QUEUE I-BURN 3>>
			      <TELL
"\"Thank you. New navigational program will initiate in fifteen seconds.
There will be a course correction burn of " N <+ 30 <RANDOM 30>> " seconds
duration. I advise you to fasten your seat belt.\"" CR>)
			     (ELSE
			      <TELL
"\"No pending program. Confirmation ignored.\"" CR>)>)
		      (<VERB? LAND>
		       <COND (,PRSO
			      <COND (<==? ,PRSO ,ARTIFACT>
				     <PERFORM ,V?LAND>
				     <RTRUE>)
				    (ELSE
				     <PERFORM ,V?SET ,COURSE ,PRSO>
				     <RTRUE>)>)
			     (,DOCKED? <TELL
"\"Error. I am already landed. Program cancelled.\"" CR>)
			     (<G? ,VIEW-COUNT 0>
			      <TELL
"\"Working...working...program aborted. The object is spinning too fast for a
safe landing. I can maintain current synchronized course indefinitely.\"" CR>)
			     (ELSE <TELL
"\"Program cancelled. There is nothing nearby to land on.\"" CR>)>)
		      (<VERB? EXAMINE>
		       <COND (<EQUAL? ,PRSO ,MISSION-STATUS ,COURSE>
			      <PERFORM ,V?REPORT ,MISSION-STATUS>
			      <RTRUE>)
			     (ELSE <TELL
"\"Your eyes are better than mine for that.\"" CR>)>)
		      (<VERB? HELLO> <TELL "\"Hello, astronaut.\"" CR>)
		      (<VERB? FIND>
		       <COND (<==? ,PRSO ,ME>
			      <PERFORM ,V?REPORT ,MISSION-STATUS>
			      <RTRUE>)
			     (<SET N <KNOWN-COURSE ,PRSO <>>>
			      <REPORT-LOCATION ,PRSO .N 1>)
			     (ELSE
			      <TELL "\"I don't know where that is.\"" CR>)>)
		      (<OR <AND <VERB? REPORT>
				<==? ,PRSO ,MISSION-STATUS>>
			   <AND <VERB? SGIVE GIVE>
				<EQUAL? ,MISSION-STATUS ,PRSO ,PRSI>>>
		       <COND (,LOST
			      <TELL
"\"We're on our way somewhere unpromising, that's all I can tell you.\"" CR>)
			     (,GIVE-UP
			      <TELL
"\"You've given up and are heading for " D ,GIVE-UP ", remember?\"" CR>)
			     (,DOCKED?
			      <TELL
"\"We've docked with this odd object. I think those tentacles may have
broken something; I don't feel too well.\"" CR>)
			     (<G? ,VIEW-COUNT 0>
			      <TELL
"\"We're on a parallel course with a strange, rotating artifact.\"" CR>)
			     (<G? ,TRIP-COUNT 0>
			      <TELL
"\"We're heading towards that newly reported unknown mass.">
			      <COND (<G? ,TRIP-COUNT 2>
				     <TELL
" We are being scanned by radiation emanating from that mass.">)>
			      <TELL "\"" CR>)
			     (,COUNTDOWN
			      <TELL
"\"Counting down to course correction.\"" CR>)
			     (,GOT-INSTRUCTIONS
			      <TELL
"\"Waiting for confirmation of new course.\"" CR>)
			     (<AND <0? ,R-VALUE>
				   <0? ,THETA-VALUE>
				   <0? ,PHI-VALUE>>
			      <TELL
"\"The mass detector has reported discovery of a new mass concentration.
Other than that, things have been pretty dull around here.\"" CR>)
			     (ELSE
			      <TELL
"\"We have a partially specified new course:">
			      <COND (<NOT <0? ,R-VALUE>>
				     <TELL " R is " N ,R-VALUE ".">)>
			      <COND (<NOT <0? ,THETA-VALUE>>
				     <TELL " Theta is " N ,THETA-VALUE ".">)>
			      <COND (<NOT <0? ,PHI-VALUE>>
				     <TELL " Phi is " N ,PHI-VALUE ".\"">)>
			      <CRLF>)>)
		      (<AND <VERB? LAMP-OFF> <==? ,PRSO ,ALARM>>
		       <COND (<NOT ,ALARM?>
			      <TELL "\"It's not on...\"" CR>)
			     (T
			      <TELL "\"And about time...\"" CR>
			      <SETG ALARM? <>>
			      <QUEUE I-ALARM 0>)>)
		      (<VERB? WAIT>
		       <TELL
"\"I can wait quite easily. Probably more easily than you.\"" CR>)
		      (<AND <VERB? KILL ATTACK MUNG> <==? ,PRSO ,ME>>
		       <TELL
"\"That is not among my capabilities. Sigh.\"" CR>)
		      (<PROB 25>
		       <TELL
"\"That is not among my capabilities. Perhaps if you were to invest in
a few upgrades I could do some of these things, but no...\"" CR>)
		      (ELSE
		       <TELL
"\"I'm only a navigational computer. That is not one of my functions.\"" CR>)>)
	       (<VERB? HELLO>
		<TELL
"\"I haven't the patience for small talk.\"" CR>)
	       (<VERB? LAMP-ON>
		<COND (,COMPUTER-ON
		       <ALREADY "on" ,COMPUTER>)
		      (ELSE
		       <SETG COMPUTER-ON T>
		       <TELL "The computer comes on." CR>)>)
	       (<VERB? LAMP-OFF>
		<COND (,COMPUTER-ON
		       <SETG COMPUTER-ON <>>
		       <TELL
"\"If you insist, but my programming impels me to come back on if
anything important happens.\"" CR>)
		      (ELSE <ALREADY "off" ,COMPUTER>)>)
	       (<VERB? GIVE>
		<TELL
"\"I might be able to take that if you had bought the extensors I asked for,
but no...\"" CR>)
	       (<AND <VERB? TELL> <NOT ,P-CONT>>
		<TELL "\"Yes?\"" CR>)>>

<GLOBAL IN-TRANSIT
"\"We're in the midst of a trip. Are you still asleep?\"">

<GLOBAL BURN-COMING
"\"I'm too busy, I've got a burn coming. You'd better brace yourself.\"">

<GLOBAL ROPES-OFF
"\"I wouldn't try leaving unless you can get those ropes off me.\"">

<GLOBAL SEAT-BELT? <>>

<ROUTINE I-BURN ()
	 <SETG COUNTDOWN <>>
	 <ROB ,DEEP-SPACE>
	 <TELL
"The ship's thrusters spin it into a proper attitude, and then the engines
begin their course correction burn. There are significant G's and not
a little vibration." CR>
	 <COND (,SEAT-BELT?
		<TELL "Fortunately, you are securely belted in." CR>
		<SETG COURSE-SELECTED T>
		<ENABLE <QUEUE I-TRIP 3>>)
	       (ELSE
		<SETG R-VALUE 0>
		<SETG THETA-VALUE 0>
		<SETG PHI-VALUE 0>
		<SETG GOT-INSTRUCTIONS <>>
		<SETG WINNER ,ADVENTURER>
		<JIGS-UP
"The G forces drive you against the rear bulkhead (which is unpadded,
of course). You are crushed to death.">)>>

<GLOBAL COURSE-SELECTED <>>

<GLOBAL TRIP-COUNT 0>

<GLOBAL TRIP-DESCS <LTABLE
 "You are headed towards a bright starlike object."
 "The starlike object now shows some shape."
 "You are approaching a huge, cylindrical asteroid."
 "The asteroid is unnaturally smooth, but there are surface features on it."
 "Filling space before you is an enormous artifact, more than 5 km long
and about a kilometer in diameter. Regularly spaced around its waist are
bumps and other odd protrusions. You cannot see the aft end but the fore
end sports a glass or crystal dome almost 100 meters across.">>

<ROUTINE I-TRIP ()
	 <TELL "Time passes as you journey towards your destination." CR>
	 <SETG TRIP-COUNT <+ ,TRIP-COUNT 1>>
	 <COND (,GIVE-UP
		<TELL
"|
You arrive at " D ,GIVE-UP " safe and sound. It would be tedious to continue,
as " D ,GIVE-UP " has no prospects as a locale for quantum black holes, so
this is the end.|
">
		<FINISH>
		<RTRUE>)>
	 <COND (<EQUAL? ,HERE
			,SPACESHIP-BRIDGE ,SPACESHIP-AIRLOCK ,DEEP-SPACE>
		<COND (<OR ,LOST <NOT <==? ,DESTINATION ,MASS>>>
		       <TELL "There is nothing interesting visible ahead." CR>)
		      (ELSE
		       <TELL <GET ,TRIP-DESCS ,TRIP-COUNT> CR>)>)>
	 <COND (<==? ,TRIP-COUNT 5>
		<COND (,LOST
		       <TELL
"You have reached your destination. The computer speaks: \"There's
nothing here, as I predicted. You never listen do you? This trip is over;
See if I'll ever work with you again...\"|
|" CR>
		       <FINISH>)
		      (<==? ,DESTINATION ,MASS>
		       <TELL
"There is a brief burn as the ship matches course with the artifact. You
are hanging in space about half a kilometer away from the waist of the object.
The Starcross's engines shut down. The computer speaks: \"Program completed.
We are being scanned by low level radiation. Awaiting instructions.\"" CR>
		       <SETG VIEW-COUNT 1>
		       <ENABLE <QUEUE I-VIEW 2>>
		       <SETG ORBIT-MATCHED T>)
		      (ELSE
		       <TELL
"Ahead is a nondescript nickel-iron asteroid, rather a small one too.
Obviously, you have picked the wrong destination.|
|" CR>
		       <FINISH>)>)
	       (ELSE
		<COND (<AND <NOT ,LOST>
			    <==? ,DESTINATION ,MASS>>
		       <COND (<==? ,TRIP-COUNT 3>
			      <TELL
"The computer says, \"Telescopic observations reveal the object ahead to
be extremely regular in shape. This is not your usual asteroid.\"" CR>)
			     (<==? ,TRIP-COUNT 4>
			      <TELL
"The computer remarks: \"I detect low-level scanning taking place. The
radiation is not dangerous. I think we may be getting into something
more than we expected here.\"" CR>)>)>
		<ENABLE <QUEUE I-TRIP 3>>)>>

<GLOBAL VIEW-COUNT 0>
<GLOBAL ORBIT-MATCHED <>>

<ROUTINE I-VIEW ()
	 <COND (<EQUAL? ,HERE ,SPACESHIP-BRIDGE ,SPACESHIP-AIRLOCK>
		<TELL
"As the object rotates below, the features of a different area become
visible through the viewport." CR>
		<TELL <GET ,VIEW-TABLE <MOD <- ,VIEW-COUNT 1> 4>> CR>)>
	 <SETG VIEW-COUNT <+ ,VIEW-COUNT 1>>
	 <COND (<==? ,VIEW-COUNT 5> <TENTACLE-APPEARS>)
	       (ELSE <ENABLE <QUEUE I-VIEW 2>>)>>

<GLOBAL VIEW-TABLE <TABLE
"There is an area with a blue dome below. Near the dome is a spherical object
which just might be a spaceship. It is held down by silvery ropes."
"This area has a yellow dome. The surface of the object here looks damaged
and scorched, and is littered with tangled debris."
"This area has a green dome and a long, silvery spaceship tethered nearby."
"Below is an area with a red dome which has no ship near it.">>

<ROUTINE TENTACLE-APPEARS ()
	 <ENABLE <QUEUE I-MOUSE 1>>
	 <ENABLE <QUEUE I-BAD-AIR <+ 75 <RANDOM 50>>>>
	 <TELL
"Suddenly an odd protrusion near the red dome splits open and a huge
articulated metal tentacle issues from it at great speed.">
	 <COND (<EQUAL? ,HERE ,DEEP-SPACE>
		<CRLF>
		<JIGS-UP
"The tentacle grabs the Starcross, spinning you off into the depths of
space!">)
	       (<EQUAL? ,HERE ,SPACESHIP-BRIDGE ,SPACESHIP-AIRLOCK>
		<TELL
" It approaches the ship and delicately wraps itself around the hull."> <COND (,SEAT-BELT?
			  <TELL
	        " You are slammed against your seat">)
			 (ELSE
			  <TELL
		" You are smashed against the bulkhead">)>
		   <TELL " as the tentacle accelerates the Starcross to the
artifact's speed of rotation. Inexorably, your ship is drawn toward the dome.
When you are a few tens of meters away, three smaller tentacles issue forth
and grapple the ship solidly to the surface of the artifact. The large
tentacle retreats into its housing, which closes.|">
<COND (,SEAT-BELT?
       <TELL
"|
You are disoriented: now that you are attached to the artifact, which is
rotating, \"up\" and \"down\" have taken on new meanings. Your sense
of balance tells you that your ship is clinging to the underside of some
enormous object, and if you aren't careful you will fall! \"Up\" now
refers to the center of the object, \"down\" to the immensities of space." CR>)
      (ELSE
       <JIGS-UP "Unfortunately, the accelerations involved were tremendous,
and being smashed into the walls didn't help your condition either.">)>)
	       (ELSE
		<JIGS-UP
"Something has grabbed the ship! You are slammed against the bulkhead!
After a great deal of buffeting, there is a metallic clang and the ship is
at rest, but unfortunately, so are you.">)>
	 <SETG DOCKED? T>>

<GLOBAL DOCKED? <>>

<GLOBAL TAPE-ON <>>

<ROUTINE TAPE-FCN ()
	 <COND (<VERB? TAKE>
		<COND (<IN? ,TAPE-PLAYER ,SPIDER>
		       <TELL "The spider refuses to part with it." CR>)
		      (ELSE <RFALSE>)>)
	       (<NOT <IN? ,TAPE-PLAYER ,WINNER>>
		<DONT-HAVE ,TAPE-PLAYER>)
	       (<VERB? LAMP-ON>
		<COND (,TAPE-ON
		       <ALREADY "on" ,TAPE-PLAYER>)
		      (ELSE
		       <SETG TAPE-ON T>
		       <TELL "The " D ,PRSO " comes on." CR>)>)
	       (<VERB? LAMP-OFF>
		<COND (,TAPE-ON
		       <SETG TAPE-ON <>>
		       <TELL "The " D ,PRSO " is now off." CR>)
		      (ELSE <ALREADY "off" ,TAPE-PLAYER>)>)
	       (<VERB? PLAY WEAR>
		<COND (<NOT ,TAPE-ON>
		       <TELL "First, you must turn on the tape player." CR>)
		      (ELSE
		       <TELL
"The player picks a recently referenced selection: ">
		       <TELL <PICK-ONE ,TAPES> CR>)>)
	       (<VERB? LISTEN>
		<COND (,TAPE-ON
		       <TELL
"The tape player continues with the previous selection." CR>)
		      (ELSE <TELL "The player isn't on." CR>)>)>>

<GLOBAL TAPES
	<LTABLE
	 "A lecture on the history of Brazil in the 2030's begins."
	 "This is a discussion of contemporary trends in literature."
	 "Bach's \"The Well-Tempered Clavier\" is played."
	 "\"Fantasia,\" complete with holo-projection, begins."
	 "A list of the works of Edgar Rice Burroughs is read off."
	 "This is Pynchon's \"Gravity's Rainbow.\""
	 "Vernon's \"Origins of the Third World War\" plays."
	 "The classic computer mystery \"Deadline\" is displayed.">>

\

<ROUTINE MOUSE-CONT ()
	 <COND (<VERB? TAKE>
		<TELL
"The maintenance mouse buzzes briefly, then rotates its \"ears\" in your
direction as you take the " D ,PRSO ". It seems profoundly puzzled at
your behavior." CR>
		<RFALSE>)>>

<ROUTINE MOUSE-GOODIES ()
	 <COND (<FIRST? ,MOUSE>
		<TELL " It has already collected ">
		<PRINT-CONTENTS ,MOUSE>
		<TELL ".">)>
	 <RTRUE>>

<ROUTINE MOUSE-FCN ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-OBJDESC>
		<COND (<IN? ,MOUSE ,GARAGE>
		       <TELL
"There is a maintenance mouse here.">)
		      (,SEEN-MOUSE?
		       <TELL
"There is a maintenance mouse here, cheerfully scouring the area for garbage.">
		       <MOUSE-GOODIES>)
		      (ELSE
		       <SETG SEEN-MOUSE? T>
		       <TELL
"A small metal contraption about a meter long and half a meter high
enters the room." ,LONG-MOUSE>)>
		<CRLF>)
	       (<AND <NOT <IN? ,MOUSE ,HERE>>
		     <OR <EQUAL? ,GLOBAL-MOUSE ,PRSO ,PRSI>
			 <EQUAL? ,MOUSE ,PRSO ,PRSI> ;"CHOMPING AGAIN">>
		<COND (<VERB? FOLLOW>
		       <COND (<NOT ,LIT>
			      <TELL "It's too dark to follow the mouse." CR>)
			     (,GARAGED?
			      <TELL "You can't go through the hole." CR>)
			     (,MFOLLOW
			      <DO-WALK ,MFOLLOW> <RTRUE>)
			     (ELSE
			      <TELL "You've lost him." CR>)>)
		      (ELSE <TELL "There is no mouse here." CR>)>)
	       (<VERB? FOLLOW>
		<TELL "He's right here!" CR>)
	       (<AND <VERB? ZAP> <CAN-ZAP?>>
		<DISABLE <INT I-MOUSE>>
		<REMOVE ,MOUSE>
		<TELL "The mouse is obliterated, squealing piteously." CR>)
	       (<VERB? MUNG>
		<TELL "The maintenance mouse is unscathed." CR>)
	       (<VERB? EMPTY>
		<COND (<ROB ,MOUSE ,WINNER>
		       <TELL "You get some booty!" CR>)>)
	       (<VERB? EXAMINE LOOK-INSIDE>
		<COND (<VERB? EXAMINE>
		       <TELL
"The maintenance mouse is a boxy machine with a large receptacle on top in
which garbage it collects can be stored. It is buzzing around cleaning the
area, diligently polishing the floor, and waving its \"ears\" (small dish
antennae) about." CR>)>
		<COND (<FIRST? ,MOUSE>
		       <TELL "The receptacle on the mouse's back contains: ">
		       <PRINT-CONTENTS ,MOUSE>
		       <TELL "." CR>)
		      (ELSE <TELL "The receptacle is empty." CR>)>)
	       (<VERB? LOOK-UNDER> <TELL "There is no dirt there." CR>)
	       (<VERB? BOARD>
		<TELL
"The mouse buzzes piteously from the overload until you get back off.
It only wants to collect small pieces of debris." CR>)
	       (<VERB? OPEN CLOSE>
		<TELL
"The mouse has no lid, just an open receptacle on its back." CR>)>>

<GLOBAL LONG-MOUSE " Its guidance system (two dish antennae at the front)
circles quizzically. A power antenna juts from the rear. On top is a small
tray. It cleans the floor as it goes, humming contentedly. All in all, it
looks like nothing so much as a mechanical mouse.">

<ROUTINE OUT-OF-HOLE ()
	 <COND (<AND ,SEEN-MOUSE? ,LIT>
		<TELL
"A maintenance mouse" ,HOLE-SHUTS "."  CR>)
	       (ELSE
		<SETG SEEN-MOUSE? T>
		<TELL
"A small metal contraption" ,HOLE-SHUTS ". The device stops in its tracks and
buzzes briefly, allowing you a closer look." ,LONG-MOUSE CR>)>
	 <RTRUE>>

<GLOBAL HOLE-SHUTS
" emerges from a hitherto unnoticed hole in the wall. The hole slides shut and
becomes practically invisible">

<GLOBAL SEEN-MOUSE? <>>
<GLOBAL MOUSE-LOC <>>
<GLOBAL GARAGED? <>>
<GLOBAL MFOLLOW <>>

<ROUTINE I-MOUSE ("AUX" (OLDM <LOC ,MOUSE>) (HERE? <IN? ,MOUSE ,HERE>)
		  ROBBED?)
	 <ENABLE <QUEUE I-MOUSE 2>>
	 <REMOVE ,MOUSE-HOLE>
	 <SETG GARAGED? <>>
	 <SET ROBBED? <ROB <LOC ,MOUSE> ,MOUSE>>
	 <COND (<AND .ROBBED? .HERE? <NOT <IN? ,MOUSE ,GARAGE>>>
		<COND (,LIT
		       <TELL
"The maintenance mouse, buzzing happily, picks up some refuse." CR>)
		      (ELSE <TELL "You hear a cheerful buzzing nearby." CR>)>)>
	 <COND (<IN? ,MOUSE ,GARAGE>
		<COND (<FIRST? ,MOUSE>
		       <ROB ,MOUSE ,TRASH-BIN>
		       <COND (<IN? ,BLUE-DISK ,TRASH-BIN>
			      <MOVE ,BLUE-DISK ,GARAGE>)>
		       <COND (<IN? ,RED-DISK ,TRASH-BIN>
			      <MOVE ,RED-DISK ,GARAGE>)>
		       <COND (<AND .HERE? ,LIT>
			      <TELL
"The mouse rolls up to the trash bin and dumps some stuff into it." CR>)>)>
		<COND (<PROB 40>
		       <COND (<AND .HERE? ,LIT>
			      <TELL
"The mouse leaves as unobtrusively as it arrived." CR>)>
		       <MOVE ,MOUSE ,MOUSE-LOC>
		       <COND (<==? ,MOUSE-LOC ,HERE>
			      <MOVE ,MOUSE-HOLE ,HERE>
			      <OUT-OF-HOLE>)>)>
		.HERE?)
	       (<AND .HERE? <PROB 30>>
		<COND (,LIT
		       <TELL
"The maintenance mouse sits in the middle of the room, buzzing
contentedly." CR>)
		       (ELSE <TELL "There is buzzing nearby." CR>)>)
	       (<AND <FIRST? ,MOUSE> <PROB 15>>
		<SETG MOUSE-LOC <LOC ,MOUSE>>
		<MOVE ,MOUSE ,GARAGE>
		<SETG GARAGED? T>
		<COND (<==? ,HERE ,GARAGE>
		       <COND (,LIT
			      <TELL
"A maintenance mouse enters the garage, preparing to dump a load of
trash." CR>)>)
		      (.HERE?
		       <MOVE ,MOUSE-HOLE .HERE?>
		       <COND (,LIT
		       <TELL
"The mouse disappears into a heretofore unnoticed hole in the wall, which
closes and becomes nearly invisible." CR>)>)>)
	       (ELSE
		<MOVE-MOUSE>
		<SET ROBBED? <ROB <LOC ,MOUSE> ,MOUSE>>
		<COND (<NOT <IN? ,MOUSE ,HERE>>
		       <COND (<AND .HERE? ,LIT>
			      <TELL
"The maintenance mouse glides happily away, looking for new dirt to
conquer." CR>
			      <RTRUE>)>)
		      (<AND <NOT ,SEEN-MOUSE?> ,LIT>
		       <MOUSE-FCN ,M-OBJDESC>)
		      (,LIT
		       <TELL
"A maintenance mouse buzzes into the room, intent on trash.">
		       <MOUSE-GOODIES>
		       <CRLF>)>
		<SET HERE? <IN? ,MOUSE ,HERE>>
		<COND (<NOT ,LIT> T)
		      (.ROBBED?
		       <COND (.HERE?
			      <TELL
"The mouse collects some discarded items." CR>)>)
		      (.HERE?
		       <TELL
"The mouse is diligently cleaning the floor and looking for garbage." CR>)>)>
	 <IN? ,MOUSE ,HERE>>

<ROUTINE MOVE-MOUSE ("AUX" (H <LOC ,MOUSE>) (P 0) TX L (D <>))
	 <REPEAT ()
		 <COND (<L? <SET P <NEXTP .H .P>> ,LOW-DIRECTION>
			<COND (.D
			       <COND (<EQUAL? .D ,UP-A-TREE>
				      <COND (<IN? ,MOUSE ,HERE>
					     <TELL
"The mouse tries to climb a tree, but fails dismally." CR>)>
				      <RFALSE>)
				     (<EQUAL? .D ,MAZE>
				      <COND (<IN? ,MOUSE ,HERE>
					     <TELL
"The mouse tries to enter the warren, but is prodded away by several
aliens." CR>)>
				      <RFALSE>)
				     (ELSE
				      <MOVE ,MOUSE .D>)>)>
			<RTRUE>)
		       (ELSE
			<SET TX <GETPT .H .P>>
			<SET L <PTSIZE .TX>>
			<COND (<OR <EQUAL? .L ,UEXIT>
				   <AND <EQUAL? .L ,CEXIT>
					<VALUE <GETB .TX ,CEXITFLAG>>>>
			       <COND (<OR <NOT .D> <PROB 50>>
				      <COND (<IN? ,MOUSE ,HERE>
					     <SETG MFOLLOW .P>)>
				      <SET D <GETB .TX ,REXIT>>)>)>)>>>

;<ROUTINE V-MOUSE ()
	 <TELL "The mouse is in " D <LOC ,MOUSE>>
	 <COND (<FIRST? ,MOUSE>
		<TELL ", carrying ">
		<PRINT-CONTENTS ,MOUSE>)>
	 <TELL "." CR>>

<ROUTINE DOOR-PSEUDO ()
	 <COND (<VERB? THROUGH>
		<TELL "Please specify a direction." CR>)
	       (<VERB? EXAMINE> <AS-ADVERTISED>)>>

<ROUTINE HOLE-FCN ()
	 <COND (<VERB? OPEN>
		<TELL
"There is no apparent way to open the mouse hole. You can barely even see
the seam between it and the wall." CR>)
	       (<VERB? MUNG>
		<TELL
"This has no effect except making it even less obvious where the
hole is." CR>)>>

<GLOBAL TRASH-COUNT 0>

<ROUTINE TRASH-BIN-FCN ()
	 <COND (<VERB? LOOK-INSIDE EXAMINE>
		<TELL
"The bin is filled with all sorts of flotsam and jetsam. Bones, clothing,
and broken spears are just some of the items visible on the top layer.">
		<COND (<FIRST? ,TRASH-BIN>
		       <TELL " The bin also contains: ">
		       <PRINT-CONTENTS ,TRASH-BIN>
		       <TELL ".">)>
		<CRLF>)
	       (<VERB? SHAKE>
		<TELL "The bin is solidly affixed to the floor." CR>)
	       (<VERB? REACH EMPTY>
		<TELL
"There's a lot of stuff inside the bin." CR>)
	       (<VERB? SEARCH DIG THROUGH>
		<COND (<FSET? ,GREEN-KEY ,TOUCHBIT>
		       <TELL
"You find nothing else of interest." CR>)
		      (<==? ,TRASH-COUNT 0>
		       <TELL
"You have searched through part of the bin, but have found nothing of
interest." CR>
		       <SETG TRASH-COUNT 25>)
		      (<PROB ,TRASH-COUNT>
		       <MOVE ,GREEN-KEY ,TRASH-BIN>
		       <FSET ,GREEN-KEY ,TOUCHBIT>
		       <THIS-IS-IT ,GREEN-KEY>
		       <TELL
"Ahah, there's something! It appears to be a green crystal rod." CR>)
		      (ELSE
		       <SETG TRASH-COUNT <+ ,TRASH-COUNT 25>>
		       <TELL
"You continue sifting through the junk; nothing of interest turns up." CR>)>)>>

<ROUTINE HOLE-PSEUDO ()
	 <COND (<VERB? EXAMINE>
		<TELL
"The chute seems bottomless and warm air rises from it." CR>)
	       (<AND <VERB? DROP> <==? ,PRSI ,PSEUDO-OBJECT>>
		<COND (<IDROP>
		       <COND (<AND <EQUAL? ,PRSO ,SPACESUIT ,SAFETY-LINE>
				   <APPLY <GETP ,PRSO ,P?ACTION>>>
			      <RTRUE>)>
		       <REMOVE ,PRSO>
		       <TELL
"The " D ,PRSO " falls down the chute and disappears." CR>)
		      (ELSE <RTRUE>)>)
	       (<VERB? CLIMB-DOWN THROUGH>
		<JIGS-UP
"The chute leads straight to the input hopper of a fusion reactor which gets
some of its power from trash. It's now getting some of its power from you.">)>>

\

"SUBTITLE SPIDER"

<ROUTINE SPHERE-SHIP-FCN (RARG)
	 <COND (<==? .RARG ,M-ENTER>
		<ENABLE <QUEUE I-SPIDER 1>>)>>

<ROUTINE BUBBLE-ROOM-FCN (RARG)
	 <COND (<==? .RARG ,M-ENTER>
		<DISABLE <INT I-SPIDER>>)>>

<ROUTINE BUBBLE-PSEUDO ()
	 <COND (<VERB? MUNG>
		<TELL "The bubble is made of indestructible plastic." CR>)
	       (<VERB? LOOK-INSIDE>
		<TELL "You can see the dock area quite clearly." CR>)>>

<ROUTINE I-SPIDER ()
	 <COND (<OR <NOT <IN? ,SPIDER ,SPHERE-SHIP>>
		    <NOT <IN? ,ADVENTURER ,SPHERE-SHIP>>>
		<RFALSE>)>
	 <ENABLE <QUEUE I-SPIDER 1>>
	 <COND (<NOT ,REFERRED?>
		<COND (<IN? ,TAPE-PLAYER ,SPIDER>
		       <TELL
"The spider, oblivious to all else, is fiddling with the tape player.
Every so often, he makes a happy little noise." CR>)
		      (<NOT ,TALKED?>
		       <COND (<PROB 25>
			      <SPIDER-GREETING>)
			     (ELSE
			      <TELL
"The spider watches you with multifaceted eyes." CR>)>)
		      (ELSE
		       <TELL
"The spider sidles along the wires towards you. ">
		       <TELL "He asks " <PICK-ONE ,SPIDER-QUESTIONS> CR>)>)
	       (ELSE <SETG REFERRED? <>>)>>

<GLOBAL SPIDER-QUESTIONS
	<LTABLE
"you a question about Earth, a rather abstruse one."
"who won the World Cup this year."
"if you have read any good books lately."
"what your astrological sign is."
"your views on the Luna City Manifesto.">>

<GLOBAL REFERRED? <>>
<GLOBAL TALKED? <>>

<ROUTINE TRANSLATOR-FCN ()
	 <COND (<VERB? ZAP> <PERFORM ,V?ZAP ,ZAP-GUN ,SPIDER> <RTRUE>)>>

<ROUTINE SPIDER-FCN ()
	 <SETG REFERRED? T>
	 <COND (<==? ,SPIDER ,WINNER>
		<COND (<NOT ,TALKED?>
		       <SPIDER-GREETING>)>
		<COND (<IN? ,TAPE-PLAYER ,SPIDER>
		       <TELL ,ENGROSSED CR>)
		      (<VERB? EXAMINE FIND IS-IN FOLLOW>
		       <TELL
"\"I can't help you there, I'm afraid. I'm quite a stay-at-home, I haven't
left my ship for ages; nothing interesting out there any more. Those furry
ones were interesting for a while but they're stagnant now.\"" CR>)
		      (<AND <VERB? TAKE> <==? ,PRSO ,TAPE-PLAYER>>
		       <SETG WINNER ,ADVENTURER>
		       <PERFORM ,V?GIVE ,PRSO ,SPIDER>
		       <RTRUE>)
		      (<VERB? TAKE DROP ATTACK KILL MUNG>
		       <TELL
"\"I couldn't do that. You're just joking, of course. You humans have a
strange idea of humor." CR>)
		      (<VERB? GIVE SGIVE>
		       <TELL
"\"No, thank you.\" He seems offended that you would ask for an outright
gift." CR>)
		      (ELSE
		       <TELL
"\"I see. Thank you.\" He seems quite pleased." CR>)>)
	       (<VERB? EXAMINE> <TELL <GETP ,SPIDER ,P?LDESC> CR>)
	       (<VERB? MUNG ZAP>
		<JIGS-UP
"Bad idea. The spider tears you apart with two of its arms.">)
	       (<IN? ,TAPE-PLAYER ,SPIDER>
		<SETG P-CONT <>>
		<TELL ,ENGROSSED CR>)
	       (<VERB? HELLO TELL>
		<COND (<NOT ,TALKED?>
		       <SPIDER-GREETING>
		       <COND (<VERB? TELL> <RFALSE>)
			     (ELSE <SETG P-CONT <>> <RTRUE>)>)
		      (<VERB? HELLO>
		       <TELL "\"Hello, again.\"" CR>)>)
	       (<VERB? GIVE>
		<COND (<==? ,PRSO ,TAPE-PLAYER>
		       <SETG TALKED? T>
		       <MOVE ,YELLOW-KEY ,HERE>
		       <MOVE ,PRSO ,SPIDER>
		       <FSET ,PRSO ,NDESCBIT>
		       <FCLEAR ,PRSO ,TAKEBIT>
		       <PUTP ,SPIDER ,P?LDESC
"There is a giant spider here, listening to a tape player.">
		       <TELL
"The spider examines the tape player and discovers the controls. A random
song begins playing. Agitated, he fiddles with the controls again, and a
lecture begins. He becomes even more agitated. \"What a wonderful gift,
human! This will alleviate my boredom for a while. Your culture is young,
but you have amassed enough of interest to keep me sane for a few more years.
I thank you.\" He fishes in a pouch and comes up with something. \"Perhaps
you may find some use for this; I long ago grew bored with such baubles.\" He
tosses a yellow crystal rod at your feet." CR>)
		      (ELSE
		       <TELL
"He takes the " D ,PRSO " politely, looks it over for a moment, and gives
it back. \"No, thank you,\" he sighs." CR>)>)>>

<GLOBAL ENGROSSED 
"Gurthark, engrossed in the tape library, pays no attention to you.">

<ROUTINE SPIDER-GREETING ()
	 <SETG TALKED? T>
	 <TELL
"The spider draws forth an object from a wire clump. He fiddles with it and
a voice issues from it: \"Greetings, creature from Earth. Are you afraid of
me? Come closer, I won't harm you.\"|
|
The spider tells you his name is \"Gurthark-tun-Besnap,\" (or something
more-or-less that). Like yourself, he landed here to explore. He failed to
control the artifact before it left his system, and has been stranded here
for centuries. He sighs. \"It's getting a little boring. The other inhabitants
of this place are not too stimulating. The computer was some company until it
malfunctioned. When we began to approach your system, I got excited! A whole
new culture to learn! The end of boredom, for a while at least. I fed your
language to my translator, from your radio broadcasts, and have eagerly
awaited your arrival.\" He grins broadly, a fairly horrific sight." CR>>

\

"SUBTITLE FORCE FIELD AND TRANSPORTER DISKS"

<ROUTINE GLOBE-SIZE (N)
	 <TELL "The silvery globe is the size of ">
	 <COND (<==? .N 1>
		<TELL "an orange">
		<COND (<IN? ,BLUE-KEY ,FORCE-FIELD-1>
		       <TELL
". Imbedded in the silver globe is a blue crystal rod">)>)
	       (<==? .N 2> <TELL "a basketball">)
	       (<==? .N 3> <TELL "a beachball">)
	       (T
		<TELL "four feet and seems embedded in the floor">)>
	 <TELL ".">>

<ROUTINE FF-FCN ("OPTIONAL" (RARG <>) "AUX" F)
	 <COND (<==? .RARG ,M-OBJDESC>
		<GLOBE-SIZE ,FF-STRENGTH>
		<CRLF>
		<COND (<FIRST? ,FF-HERE>
		       <PRINT-CONT ,FF-HERE <> 0>)>
		<RTRUE>)
	       (<VERB? TAKE>
		<TELL "The globe won't budge no matter how hard you try." CR>)
	       (<VERB? RUB PUSH>
		<TELL
"The globe feels neither hot nor cold. The globe doesn't move no matter how
hard you press." CR>)
	       (<VERB? CLIMB-UP CLIMB-ON BOARD>
		<TELL
"Climbing it gives you a strange feeling, so you get back down." CR>)
	       (<VERB? PUT-UNDER>
		<COND (<AND <NOT <FSET? ,PRSO ,TOUCHBIT>>
			    <NOT <TRYTAKE>>>
		       <RTRUE>)
		      (<==? ,FF-STRENGTH 4>
		       <TELL
"The globe is now touching the floor (in fact encompassing part of the
floor), so you can't put anything under it." CR>)
		      (,UNDER-GLOBE
		       <TELL
"The " D ,UNDER-GLOBE " is already under the globe." CR>)
		      (<FSET? ,PRSO ,TAKEBIT>
		       <COND (<EQUAL? ,PRSO ,RED-DISK ,BLUE-DISK>
			      <PERFORM ,V?DROP ,PRSO>)
			     (ELSE <MOVE ,PRSO ,HERE>)>
		       <SETG UNDER-GLOBE ,PRSO>
		       <FSET ,PRSO ,NDESCBIT>
		       <TELL
"The " D ,PRSO " slides under the globe." CR>)
		      (ELSE <TELL "Be serious!" CR>)>)
	       (<VERB? PUT-ON>
		<COND (<NOT <TRYTAKE>> <RTRUE>)
		      (<SET F <FIRST? ,FF-HERE>>
		       <COND (<==? .F ,BLUE-KEY>
			      <TELL
"The blue rod sticks out of the globe, preventing you from placing the "
D ,PRSO " there." CR>)
			     (ELSE
			      <TELL
"The " D .F " is already on the globe, rather precariously balanced." CR>)>)
		      (ELSE
		       <MOVE ,PRSO ,FF-HERE>
		       <TELL
"The " D ,PRSO " is now on the globe." CR>)>)
	       (<VERB? ZAP>
		<COND (<CAN-ZAP?>
		       <COND (<OR ,UNDER-GLOBE <ROB ,FF-HERE>>
			      <TELL
"The blast destroys some carelessly stored objects." CR>)>
		       <COND (,UNDER-GLOBE
			      <REMOVE ,UNDER-GLOBE>
			      <SETG UNDER-GLOBE <>>)>
		       <TELL
"The blast washes over the globe, which grows brighter and brighter as it
overloads, then with a sinister shiver, it disappears!">
		       <COND (<IN? ,BLUE-KEY ,FORCE-FIELD-1>
			      <COND (<==? ,FF-HERE ,FORCE-FIELD-1>
				     <REMOVE ,BLUE-KEY>
				     <TELL
" The blue rod is destroyed by the blast!">)
				    (<AND <EQUAL? ,WAS-UNDER-GLOBE
					     	  ,RED-DISK ,BLUE-DISK>
					  <NOT <DISKS-OFF? ,WAS-UNDER-GLOBE>>>
				     <SETG P-NUMBER 4>
				     <JUNK-INSIDE 4 2 T>)
				    (ELSE
				     <MOVE ,BLUE-KEY ,HERE>
				     <TELL
" A blue rod drops to the floor from the globe's center!">)>)>
		       <TELL " Moments later, the projector builds up
enough energy to restore the globe, and it reappears." CR>
		       <COND (<OR <ROB ,FORCE-FIELD-1 ,HERE>
				  <ROB ,FORCE-FIELD-2 ,HERE>
				  <ROB ,FORCE-FIELD-3 ,HERE>
				  <ROB ,FORCE-FIELD-4 ,HERE>
				  ;<ROB ,FF-BOWL-1 ,HERE>
				  <ROB ,FF-BOWL-2 ,HERE>
				  <ROB ,FF-BOWL-3 ,HERE>
				  <ROB ,FF-BOWL-4 ,HERE>>
			      <TELL
"(The rod wasn't the only thing which dropped.)" CR>)>
		       <RTRUE>)>)>>

<GLOBAL FF-STRENGTH 2>
<GLOBAL FF-HERE <>>
<GLOBAL FF-TABLE
	<TABLE FORCE-FIELD-1 FORCE-FIELD-2 FORCE-FIELD-3 FORCE-FIELD-4>>
<GLOBAL FF-FALLS
	<TABLE <>            FF-BOWL-2     FF-BOWL-3     FF-BOWL-4>>
<GLOBAL UNDER-GLOBE <>>
<GLOBAL WAS-UNDER-GLOBE <>>

<ROUTINE FF-ROOM-FCN (RARG)
	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"This is a glaringly lit room filled with strange devices, most completely
incomprehensible. For example, a huge projector of some sort points menacingly
at a silvery globe floating in midair in the center of the room. ">
		<GLOBE-SIZE ,FF-STRENGTH>
		<TELL
" Beneath the projector is a dial with four positions." CR>
		<COND (,UNDER-GLOBE
		       <TELL
"Lying beneath the globe is a " D ,UNDER-GLOBE "." CR>)>
		<RTRUE>)
	       (<AND <==? .RARG ,M-BEG>
		     <VERB? TAKE>
		     <==? ,PRSO ,UNDER-GLOBE>>
		<SETG UNDER-GLOBE <>>
		<RFALSE>)>>

<ROUTINE BLUE-KEY-FCN ()
	 <COND (<AND <VERB? TAKE>
		     <IN? ,PRSO ,FORCE-FIELD-1>
		     <NOT <FSET? ,PRSO ,TOUCHBIT>>>
		<TELL
"The blue rod is solidly held by the silvery globe." CR>)>>

<ROUTINE FF-DIAL-FCN ("AUX" OLD)
	 <COND (<VERB? EXAMINE>
		<TELL
"The dial has four positions. It is currently set to " <GET ,NUMTAB ,FF-STRENGTH> "." CR>)
	       (<AND <VERB? SET> <==? ,PRSI ,INTNUM>>
		<COND (<==? ,FF-STRENGTH ,P-NUMBER>
		       <TELL "That's where it's set now!" CR>)
		      (<OR <G? ,P-NUMBER 4> <L? ,P-NUMBER 1>>
		       <TELL
"The dial is clearly labelled with the numbers 1 to 4." CR>)
		      (ELSE
		       <TELL
"The globe flickers out for an instant and then reappears, ">
		       <COND (<G? ,P-NUMBER ,FF-STRENGTH> <TELL "expanded">)
			     (ELSE <TELL "shrunken">)>
		       <TELL ". ">
		       <GLOBE-SIZE ,P-NUMBER>
		       <CRLF>
		       <COND (<AND <==? ,FF-STRENGTH 4> ,WAS-UNDER-GLOBE>
			      <SETG UNDER-GLOBE ,WAS-UNDER-GLOBE>
			      <FCLEAR ,WAS-UNDER-GLOBE ,INVISIBLE>
			      <SETG WAS-UNDER-GLOBE <>>)
			     (<AND <==? ,P-NUMBER 4> ,UNDER-GLOBE>
			      <SETG WAS-UNDER-GLOBE ,UNDER-GLOBE>
			      <FSET ,WAS-UNDER-GLOBE ,INVISIBLE>
			      <SETG UNDER-GLOBE <>>)>
		       <SET OLD ,FF-HERE>
		       <REMOVE ,FF-HERE>
		       <SETG FF-HERE <GET ,FF-TABLE <- ,P-NUMBER 1>>>
		       <MOVE ,FF-HERE ,FF-ROOM>
		       <COND (<G? ,P-NUMBER ,FF-STRENGTH>
			      <JUNK-INSIDE ,P-NUMBER ,FF-STRENGTH>)
			     (ELSE
			      <JUNK-OUTSIDE ,P-NUMBER ,FF-STRENGTH>)>
		       <SETG FF-STRENGTH ,P-NUMBER>)>)>>

<ROUTINE V-FALL () <TELL "Fallen." CR>>

<ROUTINE JUNK-INSIDE (NEW OLD "OPTIONAL" (KEY? <>) "AUX" DEST RO RI)
	 <SET DEST <GET ,FF-FALLS <- .NEW 1>>>
	 <COND (<AND <==? ,P-NUMBER 4>
		     <OR <==? ,WAS-UNDER-GLOBE ,BLUE-DISK>
			 <==? ,WAS-UNDER-GLOBE ,RED-DISK>>>
		<SET DEST ,WAS-UNDER-GLOBE>)>
	 <SET RO <ROB <GET ,FF-TABLE <- .OLD 1>> .DEST>>
	 <COND (<SET RI <GET ,FF-FALLS <- .OLD 1>>>
		<SET RI <ROB .RI .DEST>>)>
	 <COND (<OR .RO .RI .KEY?>
		<COND (<AND <==? ,P-NUMBER 4>
			    <EQUAL? ,WAS-UNDER-GLOBE ,BLUE-DISK ,RED-DISK>
			    <NOT <DISKS-OFF? ,WAS-UNDER-GLOBE>>>
		       <TELL
"You hear the hum of the transporter disk activating." CR>
		       <COND (.RI <PERFORM ,V?FALL .RI ,WAS-UNDER-GLOBE>)>
		       <COND (.RO <PERFORM ,V?FALL .RO ,WAS-UNDER-GLOBE>)>
		       <COND (.KEY?
			      <MOVE ,BLUE-KEY ,WAS-UNDER-GLOBE>
			      <PERFORM ,V?FALL ,BLUE-KEY ,WAS-UNDER-GLOBE>)>
		       <COND (<AND <IN? ,BLUE-KEY ,FORCE-FIELD-1>
				   <IN? <LOC <OTHER-DISK ,WAS-UNDER-GLOBE>>
					,ROOMS>>
			      <SCORE-OBJ ,BLUE-KEY>
			      <FSET ,BLUE-KEY ,TOUCHBIT>
			      <MOVE ,BLUE-KEY <OTHER-DISK ,WAS-UNDER-GLOBE>>)>
		       <RTRUE>)
		      (ELSE
		       <TELL
"You hear something fall inside the sphere." CR>)>)>
	 <RTRUE>>

<GLOBAL SPHERE-SHRINKS "When the sphere shrinks, the ">

<ROUTINE JUNK-OUTSIDE (NEW OLD "AUX" R)
	 <COND (<SET R <ROB <GET ,FF-TABLE <- .OLD 1>> ,FF-ROOM>>
		<TELL
,SPHERE-SHRINKS D .R " falls to the new surface and then
slides to the floor." CR>)>
	 <COND (<SET R <ROB <GET ,FF-FALLS <- .OLD 1>> ,FF-ROOM>>
		<TELL
,SPHERE-SHRINKS D .R " falls">
		<COND (<EQUAL? ,UNDER-GLOBE ,RED-DISK ,BLUE-DISK>
		       <TELL ". "> 
		       <MOVE .R ,WINNER> ;"Kludge: make DROP work"
		       <PERFORM ,V?DROP .R ,UNDER-GLOBE>)
		      (ELSE
		       <TELL " onto the floor.">)>
		<CRLF>)>
	 <RTRUE>>

<ROUTINE DISK-FCN ("AUX" THERE OTHER)
	 <COND (<AND <VERB? TAKE> <EQUAL? ,PRSO ,RED-DISK ,BLUE-DISK>>
		<COND (<ROB ,PRSO ,HERE>
		       <TELL "The stuff on the disk falls to the ground." CR>)>
		<DISK-SWITCH ,PRSO <>>
		<RFALSE>)
	       (<AND <VERB? DROP>
		     <EQUAL? ,PRSO ,RED-DISK ,BLUE-DISK>
		     <FSET? ,HERE ,RLANDBIT>
		     <NOT ,PRSI>>
		<DISK-SWITCH ,PRSO T>
		<MOVE ,PRSO ,HERE>
		<TELL
"The " D ,PRSO " drops to the ground. There is an almost inaudible click
as it comes to rest." CR>)
	       (<AND <VERB? STAND-ON STEP-ON BOARD CLIMB-ON>
		     <EQUAL? ,PRSO ,RED-DISK ,BLUE-DISK>>
		<SET OTHER <OTHER-DISK ,PRSO>>
		<COND (<HELD? ,PRSO> <TELL "You're holding it!" CR>)
		      (<IN? ,PRSO ,MOUSE>
		       <TELL "The mouse skitters out of the way." CR>)
		      (<DISKS-OFF? ,PRSO> <TELL "Nothing happens." CR>)
		      (ELSE
		       <TELL
"There is a loud click as you step on the disk, and then a moment of
disorientation." CR>
		       <DISK-SWITCH ,RED-DISK <>>
		       <DISK-SWITCH ,BLUE-DISK <>>
		       <SET THERE <FIND-ROOM .OTHER>>
		       <COND (<EQUAL? .OTHER
				      ,UNDER-GLOBE ,WAS-UNDER-GLOBE>
			      <JIGS-UP
"You reappear amidst the sphere. Unfortunately, parts of you are inside it
and parts of you are outside it. Very untidy.">
			      <RTRUE>)>
		       <COND (<IN? .OTHER ,PRSO>
			      <REMOVE ,RED-DISK>
			      <REMOVE ,BLUE-DISK>
			      <JIGS-UP
"There is a tremendous explosion as the disk tries to transport the other
disk into itself. You are, unfortunately, intimately part of the explosion.">
			      <RTRUE>)>
		       <ROB ,PRSO .OTHER>
		       <COND (<==? ,HERE .THERE>
			      <TELL
"You reappear in the same room, but on the other disk!" CR>)
			     (ELSE
			      <CRLF>
			      <GOTO .THERE>)>)>)
	       (<AND <VERB? PUT-ON FALL>
		     <EQUAL? ,PRSI ,RED-DISK ,BLUE-DISK>>
		<COND (<NOT <FSET? ,PRSI ,TOUCHBIT>>
		       <TELL "It's on the wall!" CR>
		       <RTRUE>)
		      (<VERB? PUT-ON>
		       <COND (<NOT <TRYTAKE>> <RTRUE>)>)>
		<MOVE ,PRSO ,PRSI>
		<FSET ,PRSO ,TOUCHBIT>
		<SET OTHER <OTHER-DISK ,PRSI>>
		<COND (<DISKS-OFF? ,PRSI> <TELL "Nothing happens." CR>)
		      (<EQUAL? ,PRSO .OTHER>
		       <REMOVE ,RED-DISK>
		       <REMOVE ,BLUE-DISK>
		       <COND (<==? ,PRSI ,WAS-UNDER-GLOBE>
			      <SETG WAS-UNDER-GLOBE <>>
			      <ROB ,FF-BOWL-2>
			      <ROB ,FF-BOWL-3>
			      <ROB ,FF-BOWL-4>
			      <COND (<IN? ,BLUE-KEY ,FORCE-FIELD-1>
				     <REMOVE ,BLUE-KEY>)>
			      <TELL
"You hear a muffled explosion." CR>)
			     (ELSE
			      <SETG UNDER-GLOBE <>>
			      <SETG WAS-UNDER-GLOBE <>>
			      <TELL
"The " D ,PRSI " activates as the " D ,PRSO " touches it. It disappears
for a fraction of a second, then a flash of light fills the room as both
disks explode!" CR>)>)
		      (ELSE
		       <MOVE ,PRSO .OTHER>
		       <COND (<IN? .OTHER ,PRSI>
			      <REMOVE ,RED-DISK>
			      <REMOVE ,BLUE-DISK>
			      <TELL
"There is a tremendous explosion as the disk tries to transport the other
disk into itself." CR>
			      <RTRUE>)>
		       <ROB ,PRSI .OTHER>
		       <DISK-SWITCH ,RED-DISK <>>
		       <DISK-SWITCH ,BLUE-DISK <>>
		       <COND (<AND <IN? .OTHER ,HERE>
				   <NOT <==? .OTHER ,WAS-UNDER-GLOBE>>>
			      <COND (<AND <==? ,PRSI ,WAS-UNDER-GLOBE>
					  <==? ,P-NUMBER 4>>
				     <TELL
"There is a loud click, and then the " D ,PRSO " appears resting comfortably
on the " D <OTHER-DISK ,PRSI> ".">
				     <COND (<IN? ,BLUE-KEY ,FORCE-FIELD-1>
					    <TELL
" The blue rod must have been in range of the disk, because it appeared as
well!">)>
				     <CRLF>)
				    (T
				     <TELL
"There is a loud click from the " D ,PRSI ", and the " D ,PRSO " disappears
for a fraction of a second, then reappears resting comfortably on the "
			      D .OTHER "." CR>)>)
			     (ELSE
			      <TELL
"There is a loud click from the " D ,PRSI " and the " D ,PRSO
" disappears!" CR>)>)>)>>

"DISKS-OFF? returns true if disks can't work"

<ROUTINE DISKS-OFF? (DISK "AUX" OTHER)
	 <SET OTHER <OTHER-DISK .DISK>>
	 <COND (<OR <NOT <FSET? ,RED-DISK ,TOUCHBIT>>
		    <NOT <FSET? ,BLUE-DISK ,TOUCHBIT>>>
		<RTRUE>)
	       (<AND <==? .DISK ,RED-DISK> <NOT ,RED-DISK-ON>>
		<RTRUE>)
	       (<AND <==? .DISK ,BLUE-DISK> <NOT ,BLUE-DISK-ON>>
		<RTRUE>)
	       (<AND <NOT <FSET? <LOC .OTHER> ,RLANDBIT>>
		     <NOT <IN? .OTHER .DISK>>>
		<RTRUE>)>>

<ROUTINE FIND-ROOM (X)
	 <REPEAT ()
		 <COND (<NOT .X> ;"this can't happen, of course"
			<RETURN ,SPACESHIP-BRIDGE>)
		       (<IN? .X ,ROOMS> <RETURN .X>)>
		 <SET X <LOC .X>>>>

<ROUTINE DISK-SWITCH (WHICH NEW)
	<FSET .WHICH ,TOUCHBIT>
	<COND (<==? .WHICH ,RED-DISK> <SETG RED-DISK-ON .NEW>)
	      (ELSE <SETG BLUE-DISK-ON .NEW>)>>

<ROUTINE OTHER-DISK (DISK)
	 <COND (<==? .DISK ,RED-DISK> ,BLUE-DISK)
	       (ELSE ,RED-DISK)>>

<GLOBAL NUMTAB <LTABLE "1" "2" "3" "4">>

<ROUTINE PROJECTOR-FCN ()
	 <COND (<VERB? EXAMINE>
		<TELL
"It is a formidable looking apparatus that beams some sort of beam
directly at the silvery globe." CR>)
	       (<AND <VERB? ZAP> <CAN-ZAP?>>
		<TELL
"The projector, of the sturdiest construction, is unscathed." CR>)
	       (<VERB? MUNG>
		<TELL
"The projector is made of extremely tough plastic (yes, plastic)
and is unscathed." CR>)>>

<ROUTINE BEAM-FCN ()
	 <COND (<VERB? EXAMINE>
		<TELL
"The beam transfers some sort of energy to the globe. It is impossible to
tell any more." CR>)
	       (<AND <VERB? ZAP> <CAN-ZAP?>>
		<TELL
"The beam is pure energy, and is therefore unscathed." CR>)
	       (<VERB? MUNG>
		<TELL
"The beam seems impervious to that." CR>)>>

\

<ROUTINE AIRLOCK-EXIT-FCN ()
	 <COND (<NOT <FSET? ,AIRLOCK-OUTER ,OPENBIT>>
		<ITS-CLOSED ,AIRLOCK-OUTER>)
	       (,DOCKED?
		<TELL
"You exit gingerly, climbing \"up\" to the surface of the artifact, where
your magnetic boots hold you securely as you hang \"upside-down.\"" CR>
		<CRLF>
		,RED-DOCK)
	       (ELSE ,DEEP-SPACE)>>

<ROUTINE AIRLOCK-FCN ("OPTIONAL" (RARG ,M-BEG))
	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"This is the airlock of the Starcross. The inner door is
" <DDESC ,AIRLOCK-INNER> ", and the outer door is "
<DDESC ,AIRLOCK-OUTER> ". Neither door has a viewport.">
		<COND (<FSET? ,AIRLOCK-OUTER ,OPENBIT>
		       <TELL " Just outside the airlock is a hook.">)>
		<CRLF>)
	       (<==? .RARG ,M-BEG>
		<COND (<AND <VERB? THROUGH> <==? ,PRSO ,AIRLOCK>>
		       <COND (<==? ,HERE ,SPACESHIP-BRIDGE>
			      <DO-WALK ,P?OUT>)
			     (<==? ,HERE ,DEEP-SPACE>
			      <DO-WALK ,P?IN>)
			     (ELSE <TELL "You are in it." CR>)>
		       <RTRUE>)
		      (<AND <VERB? OPEN CLOSE>
			    <==? ,HERE ,SPACESHIP-BRIDGE>>
		       <PERFORM ,PRSA ,AIRLOCK-INNER>
		       <RTRUE>)>)>>

<ROUTINE RED-LOCK-FCN ("OPTIONAL" (RARG ,M-BEG))
	 <COND (<==? .RARG ,M-ENTER>
		<SETG IN-ARTIFACT? T>
		<RFALSE>)
	       (<==? .RARG ,M-LOOK>
		<DESCRIBE-LOCK "red" ,RED-INNER ,RED-OUTER>)>>

<ROUTINE BLUE-LOCK-FCN ("OPTIONAL" (RARG ,M-BEG))
	 <COND (<==? .RARG ,M-LOOK>
		<DESCRIBE-LOCK "blue" ,BLUE-INNER ,BLUE-OUTER>)>>

<ROUTINE GREEN-LOCK-FCN ("OPTIONAL" (RARG ,M-BEG))
	 <COND (<==? .RARG ,M-LOOK>
		<DESCRIBE-LOCK "green" ,GREEN-INNER ,GREEN-OUTER>)>>

<ROUTINE YELLOW-LOCK-FCN ("OPTIONAL" (RARG ,M-BEG))
	 <COND (<==? .RARG ,M-ENTER>
		<SETG IN-ARTIFACT? T>
		<RFALSE>)
	       (<==? .RARG ,M-LOOK>
		<DESCRIBE-LOCK "yellow" ,YELLOW-INNER ,YELLOW-OUTER>
		<COND (,ALWAYS-LIT
		       <TELL
"The room is lit by an emergency lighting system." CR>)>
		<RTRUE>)>>

<ROUTINE DESCRIBE-LOCK (COLOR INNER OUTER)
	 <TELL
"This is the main airlock of the " .COLOR " docking port. The inner door
leading up to the interior is " <DDESC .INNER> ", and the outer door leading
down to the surface is " <DDESC .OUTER> "." CR>>

<ROUTINE DDESC (D) <COND (<FSET? .D ,OPENBIT> "open")(T "closed")>>

<ROUTINE AIRLOCK-DOORS-FCN ("AUX" DIR)
	 <COND (<VERB? THROUGH>
		<COND (<==? ,HERE ,SPACESHIP-AIRLOCK>
		       <COND (<==? ,PRSO ,AIRLOCK-INNER>
			      <SET DIR ,P?WEST>)
			     (ELSE <SET DIR ,P?UP>)>)
		      (<==? ,PRSO ,AIRLOCK-INNER>
		       <SET DIR ,P?EAST>)
		      (ELSE <SET DIR ,P?DOWN>)>
		<DO-WALK .DIR>
		<RTRUE>)
	       (<VERB? OPEN CLOSE>
		<COND (<AND ,PRSO ,PRSI <==? ,PRSO ,AIRLOCK>>
		       <PERFORM ,PRSA ,PRSI>
		       <RTRUE>)
		      (<==? ,PRSO ,AIRLOCK-INNER>
		       <COND (<VERB? OPEN>
			      <COND (<IN? ,WINNER ,COUCH>
				     <TELL
"You'll have to get out of the couch first." CR>)
				    (<FSET? ,PRSO ,OPENBIT>
				     <ALREADY "open">)
				    (<FSET? ,AIRLOCK-OUTER ,OPENBIT>
				     <TELL
"Fortunately the safety interlock prevents you from evacuating the
spaceship by opening both doors of the airlock at once." CR>)
				    (ELSE
				     <DOOR-OPENS>)>)
			     (<IN? ,WINNER ,COUCH>
			      <TELL
"You'll have to get out of the couch first." CR>)
			     (<NOT <FSET? ,PRSO ,OPENBIT>>
			      <ALREADY "closed">)
			     (ELSE
			      <DOOR-CLOSES>)>)
		      (<VERB? OPEN> ;"must be outer door, then"
		       <COND (<FSET? ,PRSO ,OPENBIT>
			      <ALREADY "open">)
			     (<FSET? ,AIRLOCK-INNER ,OPENBIT>
			      <TELL
"A safety interlock prevents you from opening both doors of the airlock
simultaneously." CR>)
			     (ELSE
			      <FSET ,PRSO ,OPENBIT>
			      <VACUUM-HERE>
			      <COND (<NOT ,DOCKED?>
				     <TELL
" Outside the airlock is deep space. Beside the airlock is a safety hook
to prevent you from drifting away into space.">)>
			      <CRLF>
			      <COND (<NOT ,SUIT-ON?>
				     <JIGS-UP ,ACADEMY-DEATH>)>
			      T)>)
		      (<NOT <FSET? ,PRSO ,OPENBIT>>
		       <ALREADY "closed">)
		      (ELSE
		       <FCLEAR ,PRSO ,OPENBIT>
		       <AIR-HERE>)>)
	       (<VERB? LOOK-INSIDE>
		<COND (<NOT <FSET? ,PRSO ,OPENBIT>>
		       <TELL
"The " D ,PRSO " is closed and there is no viewport." CR>)
		      (<==? ,PRSO ,AIRLOCK-INNER>
		       <TELL "You see the bridge." CR>)
		      (,DOCKED?
		       <TELL
"You see the red docking area of the artifact, including
a dome with an airlock." CR>)
		      (ELSE <DESCRIBE-SPACE>)>)>>

<ROUTINE DOOR-OPENS ()
	 <FSET ,PRSO ,OPENBIT>
	 <TELL "The " D ,PRSO " opens." CR>>

<ROUTINE DOOR-CLOSES ()
	 <FCLEAR ,PRSO ,OPENBIT>
	 <TELL "The " D ,PRSO " closes." CR>>

<ROUTINE DEEP-SPACE-FCN ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"You are floating outside the Starcross. The airlock door
is " <COND (<FSET? ,AIRLOCK-OUTER ,OPENBIT> "open")
		(T "closed")>>
		       <COND (,THAT-END
			      <TELL ". One end of your safety line is
attached to a hook next to the airlock.">)
			     (ELSE
			      <TELL ". There is a hook next to the airlock.">)>
		       <TELL
" This is deep space, outside the plane of the ecliptic and far beyond the
orbit of Earth. The sun seems small but still intolerably bright to look at
directly." CR>
		       <DESCRIBE-SPACE>)
	       (<==? .RARG ,M-END>
		<COND (<OR <NOT ,THIS-END> <NOT ,THAT-END>>
		       <TELL
"You have left the Starcross in deep space without a safety
line, a good way to drift into space and eventually run out of air." CR>
		       <COND (<PROB 40>
			      <TELL
"So far you've been lucky and not drifted very far." CR>)
			     (ELSE <JIGS-UP
"In fact, this is exactly what has happened to you.">)>
		       <RTRUE>)>)
	       (<==? .RARG ,M-BEG>
		<COND (<VERB? THROW> <THROW-AWAY>)
		      (<AND <VERB? REACH-FOR>
			    <EQUAL? ,PRSO ,AIRLOCK-OUTER>>
		       <COND (<FSET? ,AIRLOCK-OUTER ,OPENBIT>
			      <TELL
"Just in time you pull yourself back into the airlock.|" CR>
			      <GOTO ,SPACESHIP-AIRLOCK>)
			     (ELSE
			      <TELL
"You grab for the hatch, but can't find a handhold!" CR>)>)>)>>

<ROUTINE OUTER-SPACE-FCN ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"You are floating in space above the artifact, giving you a panoramic view of
its surface. Unfortunately you will soon run out of air, which will ruin the
experience." CR>)
	       (<==? .RARG ,M-BEG>
		<COND (<VERB? THROW> <THROW-AWAY>)
		      (<AND <VERB? ZAP> <CAN-ZAP?>>
		       <JIGS-UP
"The force of the blast slows your recession from the artifact, but not
enough. You continue to drift away, and eventually run out of air.">)>)>>

<ROUTINE THROW-AWAY ()
	 <COND (<IDROP>
		<COND (<AND <EQUAL? ,PRSO ,SPACESUIT ,SAFETY-LINE>
			    <APPLY <GETP ,PRSO ,P?ACTION>>>
		       <RTRUE>)>
		<REMOVE ,PRSO>
		<TELL "The " D ,PRSO " sails away into space." CR>)
	       (ELSE <RTRUE>)>>

<GLOBAL COLOR-CODED
"This is a docking port color-coded in red. ">

<ROUTINE DESCRIBE-SPACE ()
	 <COND (,DOCKED?
		<TELL
,COLOR-CODED "Your ship is tethered securely next to a large dome
with an airlock. The surface looks metallic." CR>)
	       (<G? ,VIEW-COUNT 0>
		<TELL <GET ,VIEW-TABLE <MOD <+ ,VIEW-COUNT 2> 4>>
		      CR>)
	       (<G? ,TRIP-COUNT 0>
		<COND (<OR ,LOST <NOT <==? ,DESTINATION ,MASS>>>
		       <TELL
			"There is nothing interesting visible." CR>)
		      (ELSE
		       <TELL <GET ,TRIP-DESCS ,TRIP-COUNT> CR>)>)
	       (ELSE <TELL "You see the emptiness of space." CR>)>>

<ROUTINE SHIP-FCN ()
	 <COND (<VERB? EXAMINE>
		<COND (<OR <EQUAL? ,HERE
				   ,SPACESHIP-BRIDGE
				   ,SPACESHIP-AIRLOCK ,SPACESHIP-STORES>
			   <EQUAL? ,HERE ,SPACESHIP-QUARTERS ,RED-DOCK
				   ,DEEP-SPACE>>
		       <TELL "The Starcross looks the same as always." CR>)
		      (<==? ,HERE ,BLUE-DOCK ,BUBBLE-ROOM ,SPHERE-SHIP>
		       <TELL "This ship looks like a huge crystalline bubble." CR>)
		      (<==? ,HERE ,UMBILICAL>
		       <TELL
"It looks like something out of a Buck Rogers movie." CR>)
		      (ELSE
		       <TELL
"The Starcross is where you left it, presumably." CR>)>)
	       (<AND <VERB? BOARD THROUGH> <==? ,HERE ,RED-DOCK>>
		<DO-WALK ,P?SOUTH>
		<RTRUE>)>>

<ROUTINE ARTIFACT-FCN ()
	 <COND (<NOT ,DOCKED?> <TELL "What artifact?" CR>)
	       (<VERB? EXAMINE FIND>
		<COND (,IN-ARTIFACT? <TELL "It's all around!" CR>)
		      (ELSE <TELL "It's right here.!" CR>)>)>>

<GLOBAL SUIT-ON? <>>

<ROUTINE SPACESUIT-FCN ()
	 <COND (<AND <VERB? ZAP> <IN? ,SPACESUIT ,CHIEF>>
		<PERFORM ,V?ZAP ,ZAP-GUN ,CHIEF>
		<RTRUE>)
	       (<VERB? WEAR BOARD>
		<COND (,SUIT-ON? <TELL "You are already wearing it." CR>)
		      (<NOT <TRYTAKE>> <RTRUE>)
		      (ELSE
		       <SETG SUIT-ON? T>
		       <FSET ,SPACESUIT ,WEARBIT>
		       <MOVE ,SPACESUIT ,WINNER>
		       <TELL
"You are now wearing the space suit, breathing internal oxygen." CR>)>)
	       (<VERB? TAKE-OFF DISEMBARK>
		<COND (,SUIT-ON?
		       <SETG SUIT-ON? <>>
		       <SETG THIS-END <>>
		       <FCLEAR ,SPACESUIT ,WEARBIT>
		       <COND (<FSET? ,HERE ,SPACEBIT>
			      <JIGS-UP
"That was a silly thing to do, as there is no air here. You
die of all sorts of asphyxiation.">)
			     (<==? ,POISON-COUNT 4>
			      <JIGS-UP
"The air is foul and unbreathable, and you pass out almost instantly
after removing the space suit.">)
			     (ELSE
			      <TELL
"You have removed the space suit.">
			      <COND (<ON-ARTIFACT?>
				     <DESCRIBE-AIR " The air here is ">)
				    (ELSE <CRLF>)>)>)
		      (ELSE <TELL "You aren't wearing it." CR>)>)
	       (<VERB? DROP GIVE THROW PUT>
		<COND (,SUIT-ON?
		       <TELL "You'll have to take it off first!" CR>)
		      (ELSE
		       <SETG THIS-END <>>
		       <RFALSE>)>)
	       (<AND <IN? ,SPACESUIT ,CHIEF> <VERB? TAKE POINT>>
		<TELL
"The chief jumps back, annoyed. He assumes you are trying to go back on
your word." CR>)>>

<ROUTINE JUNK-SPACESUIT-FCN ()
	 <COND (<AND <IN? ,PRSO ,CHIEF> <VERB? TAKE WEAR BOARD>>
		<TELL
"The chief jumps back, annoyed. He points at you and makes a long speech
in his own language." CR>)
	       (<VERB? WEAR BOARD>
		<COND (<FSET? ,PRSO ,WEARBIT>
		       <TELL "You are already wearing it." CR>)
		      (ELSE
		       <FSET ,PRSO ,WEARBIT>
		       <MOVE ,PRSO ,WINNER>
		       <TELL
"You are now wearing the tattered old suit, which smells of alien." CR>)>)
	       (<VERB? TAKE-OFF DISEMBARK>
		<COND (<FSET? ,PRSO ,WEARBIT>
		       <FCLEAR ,PRSO ,WEARBIT>
		       <TELL
"You are no longer wearing the tattered suit." CR>)
		      (ELSE <TELL "You aren't wearing it." CR>)>)
	       (<AND <VERB? DROP GIVE> <FSET? ,PRSO ,WEARBIT>>
		<TELL "You'll have to take it off first!" CR>)>>

<GLOBAL THAT-END <>> ;"T if hooked to something"
<GLOBAL THIS-END <>> ;"T if hooked to suit"

<ROUTINE SAFETY-LINE-FCN ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-OBJDESC>
		<TELL "A safety line">
		<COND (<AND ,THIS-END <NOT <IN? ,SPACESUIT ,WINNER>>>
		       <SETG THIS-END <>>)>
		<COND (<NOT <FSET? ,SAFETY-LINE ,TOUCHBIT>>
		       <TELL " hangs on the wall." CR>
		       <RTRUE>)
		      (,THIS-END
		       <TELL " (attached to your space suit">
		       <COND (,THAT-END
			      <TELL " and a hook">)>
		       <TELL ")">)
		      (,THAT-END
		       <TELL " (attached to a hook)">)>
		<TELL " is here." CR>)
	       (<VERB? EXAMINE>
		<COND (,THIS-END
		       <TELL
"One end of the line is attached to your space suit">
		       <COND (,THAT-END
			      <TELL ", and one end to a hook">)>
		       <TELL "." CR>)
		      (,THAT-END
		       <TELL "One end of the line is attached to a hook." CR>)
		      (ELSE
		       <TELL "The line is not attached to anything." CR>)>)
	       (<VERB? TIE UNTIE>
		<COND (<NOT <IN? ,SAFETY-LINE ,WINNER>>
		       <DONT-HAVE ,SAFETY-LINE>)
		      (<VERB? TIE>
		       <COND (<==? ,PRSI ,SPACESUIT>
			      <COND (<NOT <HELD? ,SPACESUIT>>
				     <DONT-HAVE ,SPACESUIT>
				     <RTRUE>)
				    (,THIS-END
				     <ALREADY "tied" ,SPACESUIT>
				     <RTRUE>)
				    (ELSE
				     <SETG THIS-END ,SPACESUIT>)>)
			     (<==? ,PRSI ,SAFETY-HOOK>
			      <COND (,THAT-END
				     <ALREADY "tied" ,SAFETY-HOOK>
				     <RTRUE>)
				    (ELSE
				     <SETG THAT-END ,SAFETY-HOOK>)>)
			     (,PRSI
			      <TELL
"You can't attach the safety line to that." CR>
			      <RTRUE>)
			     (ELSE
			      <TELL "You must tell what to attach it to." CR>
			      <RTRUE>)>
		       <TELL "Attached to the " D ,PRSI "." CR>)
		      (<VERB? UNTIE>
		       <COND (,PRSI
			      <COND (<==? ,PRSI ,THAT-END>
				     <SETG THAT-END <>>)
				    (<==? ,PRSI ,THIS-END>
				     <SETG THIS-END <>>)
				    (ELSE
				     <TELL "It's not attached to the " D ,PRSI "." CR>
				     <RTRUE>)>
			      <TELL "Detached from the " D ,PRSI "." CR>)
			     (,THAT-END
			      <TELL "Detached from the " D ,THAT-END "." CR>
			      <SETG THAT-END <>>)
			     (,THIS-END
			      <TELL "Detached from the " D ,THIS-END "." CR>
			      <SETG THIS-END <>>)
			     (ELSE
			      <TELL "It's not attached to anything." CR>)>)>
		<RTRUE>)
	       (<VERB? PUT DROP THROW GIVE PUT-ON TAKE>
		<COND (<OR ,THIS-END ,THAT-END>
		       <TELL
"You should detach it first." CR>)>)>>

<GLOBAL DOOR-SOLVED? <>>

<ROUTINE CORIOLIS ()
	 <COND (<VERB? DROP THROW>
		<COND (<IDROP>
		       <COND (<AND <EQUAL? ,PRSO ,SPACESUIT ,SAFETY-LINE>
				   <APPLY <GETP ,PRSO ,P?ACTION>>>
			      <RTRUE>)>
		       <REMOVE ,PRSO>
		       <TELL
"As the " D ,PRSO " leaves your hand, it is thrown into space by the rotation
of the artifact." CR>)
		      (ELSE <RTRUE>)>)>>

<ROUTINE RED-DOCK-FCN (RARG)
	 <COND (<==? .RARG ,M-BEG> <CORIOLIS>)
	       (<==? .RARG ,M-ENTER>
		<SETG IN-ARTIFACT? <>>
		<RFALSE>)
	       (<==? .RARG ,M-LOOK>
		<TELL
,COLOR-CODED "All around are strange protrusions, one of which could be a
hook for a safety line. The surface here is metallic, but gets stony further
from the dock. On one side (\"Down\") is your ship, tethered to the surface
of the artifact by thick silvery ropes. On the other (\"Up\") is a large dome
with an airlock">
		<COND (<FSET? ,RED-OUTER ,OPENBIT>
		       <TELL
", which is open." CR>)
		      (T <TELL "." CR>)>)>>

<ROUTINE BLACK-KEY-FCN ()
	 <COND (<AND <VERB? TAKE>
		     <IN? ,BLACK-KEY ,RELIEF>>
		<FSET ,RED-OUTER ,OPENBIT>
		<MOVE ,BLACK-KEY ,WINNER>
		<SCORE-OBJ ,BLACK-KEY>
		<SETG DOOR-SOLVED? T>
		<TELL
"When you take the black rod, the airlock door opens!" CR>)>>

<ROUTINE RELIEF-FCN ()
	 <COND (<VERB? EXAMINE>
		<COND (<NOT <IN? ,BUMP ,RED-DOCK>>
		       <TELL
"The relief is no longer a relief. It is completely flattened out." CR>)
		      (ELSE
		       <TELL
"A closer examination reveals that there are exactly ten circular bumps or
columns on the sculpture: the first is large and centrally located, the
second through tenth are smaller and scattered at various distances and
orientations. As you go outward from the large bump in the center there are
four small bumps, two rather large ones, two medium-sized ones, and finally
a small one which sticks out quite far." CR>
		<COND (<IN? ,BABY-BUMP ,HERE>
		       <TELL
"There is also a tiny bump" ,ABOUT-SAME CR>)>)>
		T)>>

<ROUTINE INTNUM-FCN ()
	 <COND (<==? ,HERE ,RED-DOCK>
		<COND (<==? ,PRSO ,INTNUM>
		       <PERFORM ,PRSA ,BUMP ,PRSI>
		       <RTRUE>)>)>>

<ROUTINE ORDINAL (WRD)
	 <COND (<EQUAL? .WRD ,W?FIRST ,W?CENTER> 1)
	       (<==? .WRD ,W?SECOND> 2)
	       (<==? .WRD ,W?THIRD> 3)
	       (<==? .WRD ,W?FOURTH> 4)
	       (<==? .WRD ,W?FIFTH> 5)
	       (<==? .WRD ,W?SIXTH> 6)
	       (<==? .WRD ,W?SEVENTH> 7)
	       (<==? .WRD ,W?EIGHTH> 8)
	       (<==? .WRD ,W?NINTH> 9)
	       (<EQUAL? .WRD ,W?TENTH ,W?OUTER ,W?LAST> 10)
	       (T 0)>>

<ROUTINE BUMP-FCN ("AUX" N)
	 <COND (<AND <VERB? PUSH RUB>
		     <EQUAL? ,PRSO ,BUMP ,BUMP-2 ,BABY-BUMP>>
		<COND (<AND <EQUAL? ,PRSO ,BUMP ,BUMP-2>
			    <EQUAL? ,PRSI <> ,INTNUM>>
		       <COND (<EQUAL? ,PRSI ,INTNUM> T)
			     (<NOT ,P-ADJECTIVE>
			      <TELL "You didn't say which one." CR>
			      <RTRUE>)
			     (<SET N <ORDINAL ,P-ADJECTIVE>>
			      <SETG P-NUMBER .N>)
			     (T
			      <TELL "Lose, lose!" CR>
			      <RTRUE>)>)>
		<COND (<OR <==? ,PRSO ,BABY-BUMP>
			   <AND <==? ,P-NUMBER 11>
				<IN? ,BABY-BUMP ,HERE>>>
		       <REMOVE ,BABY-BUMP>
		       <REMOVE ,BUMP>
		       <REMOVE ,BUMP-2>
		       <MOVE ,BLACK-KEY ,RELIEF>
		       <PUTP ,RELIEF ,P?LDESC
"The door is covered by a smooth pattern of silver hexagons.">
		       <TELL
"The sculpture flattens out completely, except at the former location of the
tiny bump, where a hexagonal rod of black crystal is extruded." CR>)
		      (<0? ,P-NUMBER>
		       <TELL "You must specify which one." CR>)
		      (<AND <==? ,P-NUMBER 4>
			    <NOT <IN? ,BABY-BUMP ,HERE>>>
		       <MOVE ,BABY-BUMP ,HERE>
		       <TELL
"A tiny column made up of only one hexagon appears at" ,ABOUT-SAME CR>)
		      (ELSE
		       <REMOVE ,BABY-BUMP>
		       <REMOVE ,BUMP>
		       <REMOVE ,BUMP-2>
		       <PUTP ,RELIEF ,P?LDESC
"The door is covered by a smooth pattern of silver hexagons.">
		       <TELL
"All of the hexagons extend to full length, then retract into the surface,
leaving the sculpture completely smooth." CR>)>)>>

<GLOBAL ABOUT-SAME
" a distance somewhat nearer the center than the first large bump.">

<ROUTINE RED-DOORS-FCN ("AUX" DIR)
	 <COND (<VERB? THROUGH>
		<COND (<==? ,HERE ,RED-LOCK>
		       <COND (<==? ,PRSO ,RED-INNER>
			      <SET DIR ,P?UP>)
			     (ELSE <SET DIR ,P?DOWN>)>)
		      (<==? ,PRSO ,RED-INNER>
		       <SET DIR ,P?DOWN>)
		      (ELSE <SET DIR ,P?UP>)>
		<DO-WALK .DIR>
		<RTRUE>)
	       (,DOOR-SOLVED?
		<COND (<VERB? OPEN CLOSE>
		       <AIRLOCK-OPEN ,RED-INNER ,RED-OUTER ,RED-DOCK>)
		      (<VERB? LOOK-INSIDE>
		       <AIRLOCK-LOOK ,RED-INNER ,RED-THREE ,RED-DOCK>)>)
	       (<VERB? OPEN CLOSE>
		<TELL "The airlock door won't budge." CR>)>>

<ROUTINE BLUE-DOORS-FCN ("AUX" DIR)
	 <COND (<VERB? THROUGH>
		<COND (<==? ,HERE ,BLUE-LOCK>
		       <COND (<==? ,PRSO ,BLUE-INNER>
			      <SET DIR ,P?UP>)
			     (ELSE <SET DIR ,P?DOWN>)>)
		      (<==? ,PRSO ,BLUE-INNER>
		       <SET DIR ,P?DOWN>)
		      (ELSE <SET DIR ,P?UP>)>
		<DO-WALK .DIR>
		<RTRUE>)
	       (<VERB? OPEN CLOSE>
		<AIRLOCK-OPEN ,BLUE-INNER ,BLUE-OUTER ,BLUE-DOCK>)
	       (<VERB? LOOK-INSIDE>
		<AIRLOCK-LOOK ,BLUE-INNER ,BLUE-THREE ,BLUE-DOCK>)>>

<GLOBAL YELLOW-OPEN? <>>

<ROUTINE YELLOW-DOORS-FCN ("AUX" DIR)
	 <COND (<NOT ,LIT> <TELL "It is too dark here to see." CR>)
	       (<VERB? THROUGH>
		<COND (<==? ,HERE ,YELLOW-LOCK>
		       <COND (<==? ,PRSO ,YELLOW-INNER>
			      <SET DIR ,P?UP>)
			     (ELSE <SET DIR ,P?DOWN>)>)
		      (<==? ,PRSO ,YELLOW-INNER>
		       <SET DIR ,P?DOWN>)
		      (ELSE <SET DIR ,P?UP>)>
		<DO-WALK .DIR>
		<RTRUE>)
	       (<AND <==? ,PRSO ,YELLOW-OUTER>
		     <VERB? OPEN PUSH>
		     <NOT ,YELLOW-OPEN?>
		     <NOT <FSET? ,YELLOW-INNER ,OPENBIT>>>
		<TELL
"The door appears to be jammed. There may be debris outside blocking
it. Perhaps if you pushed again." CR>
		<SETG YELLOW-OPEN? T>)
	       (<VERB? OPEN CLOSE PUSH>
		<AIRLOCK-OPEN ,YELLOW-INNER ,YELLOW-OUTER ,YELLOW-DOCK>)
	       (<VERB? LOOK-INSIDE>
		<AIRLOCK-LOOK ,YELLOW-INNER ,YELLOW-THREE ,YELLOW-DOCK>)>>

<ROUTINE YELLOW-DOCK-FCN (RARG)
	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"This dock area is severely scorched and damaged where other docks have rope
housings. There was apparently a major explosion here, or possibly a
chemically fueled rocket attempted to leave without taking proper precautions.
There is a hook beside the airlock." CR>
		<COND (<IN? ,SCORCHED-ALIEN ,YELLOW-DOCK-EDGE>
		       <TELL
"Entangled in debris at the edge of the dock, to port, is what might be a
body. It is out of reach from here." CR>)>
		<RTRUE>)
	       (<==? .RARG ,M-BEG>
		<BRODY>)
	       (<==? .RARG ,M-ENTER>
		<SETG IN-ARTIFACT? <>>
		<RFALSE>)>>

<GLOBAL IN-ARTIFACT? <>>

<ROUTINE BRODY ()
	 <COND (<VERB? LEAP>
		<COND (<AND ,THIS-END ,THAT-END>
		       <TELL
"You sail into space as far as your safety line allows, and
then back again." CR>)
		      (ELSE
		       <ENABLE <QUEUE I-SUFFOCATE 5>>
		       <TELL
"You fly into space like a super-hero. Unfortunately, you keep going
indefinitely, and eventually you will run out of air." CR>
		       <CRLF>
		       <GOTO ,OUTER-SPACE>)>)
	       (ELSE <CORIOLIS>)>>

<ROUTINE YELLOW-DOCK-EXITS ()
	 <COND (<AND ,THIS-END ,THAT-END>
		<TELL
"You crawl across dock area, your magnetic boots overcoming the effect
of centripetal force. The metal area they can cling to ends before you reach
the edge of the dock, but thanks to your safety line you make it successfully
to the tangle of debris." CR>
		<CRLF>
		,YELLOW-DOCK-EDGE)
	       (ELSE
		<TELL
"You crawl across the dock area, your magnetic boots holding you safe.
Unfortunately, the metallic area ends short of the tangle of debris. If you
went further, you would be thrown into space by centripetal force." CR>
		<RFALSE>)>>

<ROUTINE YELLOW-DOCK-EDGE-FCN (RARG)
	 <COND (<==? .RARG ,M-BEG>
		<BRODY>)
	       (<==? .RARG ,M-END>
		<COND (<AND ,THIS-END ,THAT-END> <RFALSE>)
		      (ELSE
		       <ENABLE <QUEUE I-SUFFOCATE 5>>
		       <TELL
"Now that you are no longer moored by the safety line, centripetal force
throws you into space in a lovely trajectory which (as a matter of academic
interest) looks curved from your perspective as the artifact rapidly rotates
away under you." CR>
		       <CRLF>
		       <GOTO ,OUTER-SPACE>)>)>>

<ROUTINE I-SUFFOCATE ()
	 <COND (<==? ,HERE ,OUTER-SPACE>
		<JIGS-UP
"You run out of air, dying an unpleasant death \"above\" the artifact.">)>>

<ROUTINE SCORCHED-PSEUDO ()
	 <COND (<VERB? TAKE EXAMINE>
		<TELL "It's too far away." CR>)>>

<ROUTINE GREEN-DOORS-FCN ("AUX" DIR)
	 <COND (<VERB? THROUGH>
		<COND (<==? ,HERE ,GREEN-LOCK>
		       <COND (<==? ,PRSO ,GREEN-INNER>
			      <SET DIR ,P?UP>)
			     (ELSE <SET DIR ,P?DOWN>)>)
		      (<==? ,PRSO ,GREEN-INNER>
		       <SET DIR ,P?DOWN>)
		      (ELSE <SET DIR ,P?UP>)>
		<DO-WALK .DIR>
		<RTRUE>)
	       (<VERB? OPEN CLOSE>
		<AIRLOCK-OPEN ,GREEN-INNER ,GREEN-OUTER ,GREEN-DOCK>)
	       (<VERB? LOOK-INSIDE>
		<AIRLOCK-LOOK ,GREEN-INNER ,GREEN-THREE ,GREEN-DOCK>)>>

<ROUTINE AIRLOCK-OPEN (INNER OUTER OUTLOC)
	 <COND (<==? ,PRSO .INNER>
		<COND (<VERB? OPEN PUSH>
		       <COND (<FSET? ,PRSO ,OPENBIT>
			      <ALREADY "open">)
			     (<FSET? .OUTER ,OPENBIT>
			      <TELL
"It refuses to open and a bright light flashes incessantly until
you remove your hand from the door." CR>)
			     (ELSE
			      <DOOR-OPENS>)>)
		      (<NOT <FSET? ,PRSO ,OPENBIT>>
		       <ALREADY "closed">)
		      (ELSE
		       <DOOR-CLOSES>)>)
	       (<VERB? OPEN PUSH> ;"must be outer door, then"
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <ALREADY "open">)
		      (<FSET? .INNER ,OPENBIT>
		       <TELL
"A bright light over the door flashes menacingly until you remove your
hand." CR>)
		      (ELSE
		       <FSET ,PRSO ,OPENBIT>
		       <COND (<FSET? .OUTLOC ,SPACEBIT>
			      <VACUUM-HERE>
			      <CRLF>
			      <COND (<NOT ,SUIT-ON?>
				     <CRLF>
				     <JIGS-UP ,ACADEMY-DEATH>)>)
			     (T <DOOR-OPENS>)>
		       T)>)
	       (<NOT <FSET? ,PRSO ,OPENBIT>>
		<ALREADY "closed">)
	       (ELSE
		<FCLEAR ,PRSO ,OPENBIT>
		<AIR-HERE>)>>

<GLOBAL ACADEMY-DEATH "Didn't they teach you anything in the Academy? You
can't breathe vacuum! The process of dying in this way is very painful but
at least relatively short.">

<ROUTINE IN-AIRLOCK? ()
	 <OR <EQUAL? ,HERE ,RED-LOCK ,GREEN-LOCK ,YELLOW-LOCK>
	     <EQUAL? ,HERE ,BLUE-LOCK ,SPACESHIP-AIRLOCK>>>

<ROUTINE AIR-HERE ()
	 <TELL "The outer door closes">
	 <COND (<IN-AIRLOCK?>
		<FCLEAR ,HERE ,SPACEBIT>
		<TELL " and air rushes into the airlock">)>
	 <TELL "." CR>>

<ROUTINE VACUUM-HERE ()
	 <TELL "The outer door opens">
	 <COND (<IN-AIRLOCK?>
		<FSET ,HERE ,SPACEBIT>
		<TELL " and air rushes out of the airlock">)>
	 <TELL ".">>

<ROUTINE AIRLOCK-LOOK (INNER INNEXT OUTNEXT)
	 <COND (<NOT <FSET? ,PRSO ,OPENBIT>>
		<TELL
"The " D ,PRSO " is closed and there is no viewport." CR>)
	       (<==? ,PRSO .INNER>
		<GO&LOOK .INNEXT>)
	       (ELSE <GO&LOOK .OUTNEXT>)>>

<ROUTINE GO&LOOK (RM "AUX" OHERE OLIT (OSEEN <>))
	 #DECL ((RM) OBJECT)
	 <SET OHERE ,HERE>
	 <COND (<FSET? .OHERE ,TOUCHBIT>
		<SET OSEEN T>)>
	 <SET OLIT ,LIT>
	 <SETG HERE .RM>
	 <SETG LIT <LIT? .RM>>
	 <PERFORM ,V?LOOK>
	 <COND (<NOT .OSEEN> <FCLEAR .OHERE ,TOUCHBIT>)>
	 <SETG HERE .OHERE>
	 <SETG LIT .OLIT>
	 T>

<ROUTINE COUCH-FCN ("OPTIONAL" (RARG <>))
	 <COND (<NOT <==? ,HERE ,SPACESHIP-BRIDGE>>
		<COND (<VERB? CLIMB-ON CLIMB-DOWN BOARD>
		       <TELL "That seat is taken...." CR>)
		      (T <EX-CHECK>)>)
	       (<AND <VERB? EXAMINE> <==? .RARG ,M-BEG> <==? ,PRSO ,COUCH>>
		<DESCRIBE-SEAT-BELT>
		<RTRUE>)
	       (<==? .RARG ,M-BEG>
		<COND (<VERB? WALK>
		       <TELL "You'll have to stand up first." CR>)
		      (<AND <VERB? STAND DISEMBARK> ,SEAT-BELT?>
		       <TELL
			"You must unfasten your seat belt first." CR>)
		      (<VERB? CLIMB-ON CLIMB-DOWN>
		       <PERFORM ,V?BOARD ,COUCH>
		       <RTRUE>)
		      (<AND <VERB? TAKE-OFF> <==? ,PRSO ,COUCH>>
		       <PERFORM ,V?DISEMBARK ,COUCH>
		       <RTRUE>)
		      (<VERB? TAKE>
		       <TELL "You can't reach it." CR>
		       <RTRUE>)>)
	       (<==? .RARG ,M-ENTER>
		<DESCRIBE-SEAT-BELT>)>>

<ROUTINE DESCRIBE-SEAT-BELT ()
	 <TELL "The couch has a seat belt which is currently ">
	 <COND (,SEAT-BELT? <TELL "fastened." CR>)
	       (ELSE <TELL "unfastened." CR>)>>

<ROUTINE SEAT-BELT-FCN ()
	 <COND (<NOT <IN? ,WINNER ,COUCH>>
		<TELL "You must sit down first." CR>)
	       (<VERB? TIE WEAR LOCK>
		<COND (,SEAT-BELT? <TELL "It's already fastened." CR>)
		      (ELSE <SETG SEAT-BELT? T> <TELL "Click." CR>)>)
	       (<VERB? UNTIE TAKE-OFF OPEN UNLOCK REMOVE>
		<COND (<NOT ,SEAT-BELT?>
		       <TELL "It's already unfastened." CR>)
		      (ELSE <SETG SEAT-BELT? <>> <TELL "Click." CR>)>)
	       (<VERB? EXAMINE>
		<TELL "The seat belt is ">
		<COND (,SEAT-BELT? <TELL "fastened." CR>)
		      (ELSE <TELL "unfastened." CR>)>)>>

<ROUTINE BUREAU-PSEUDO ()
	 <COND (<VERB? OPEN LOOK-INSIDE>
		<TELL "There is nothing in the bureau but some clothes." CR>)>>

\

"SUBTITLE PRIMITIVE ALIENS"

<GLOBAL ALIENS-FRIENDLY? T>
<GLOBAL ALIENS-DESCRIBED? <>>

<ROUTINE VILLAGE-NW-EDGE-FCN (RARG)
	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"This is the edge of a populated area, growing denser as you move starboard.
Primitive huts line the corridor, which is blocked ahead by a palisade built of
mud and wood. An open gate, guarded by several spear-bearing aliens, leads
into the structure. A small crowd of aliens has gathered to watch you." CR>
		<COND (<NOT ,ALIENS-DESCRIBED?>
		       <SETG ALIENS-DESCRIBED? T>
		       <DESCRIBE-WEASELS>
		       <ENABLE <QUEUE I-CHIEF-APPEARS <+ 3 <RANDOM 3>>>>)>
		<COND (,ALIENS-FRIENDLY?
		       <TELL
"They gesture in a way intended to show friendship (they bare
their huge razor-sharp teeth)." CR>
		       <COND (<NOT ,HUSTLED?>
			      <TELL
"The smaller ones are hustled away, but almost immediately begin to sneak
back." CR>)>)
		      (ELSE
		       <TELL
"They stare at you with mingled awe and belligerence." CR>
		       <COND (<NOT ,HUSTLED?>
			      <TELL
"The smaller ones are hustled away, leaving only the better-armed members
of the tribe." CR>)>)>
		<SETG HUSTLED? T>
		<RTRUE>)
	       (<==? .RARG ,M-BEG>
		<COND (<OR <AND <VERB? GIVE> <==? ,PRSI ,CHIEF>>
			   <AND <VERB? DROP> <IN? ,CHIEF ,HERE>>>
		       <GIVE-TO-CHIEF>)>)>>

<ROUTINE PALISADE-FCN ()
	 <COND (<AND <VERB? ZAP> <CAN-ZAP?>>
		<SETG ALIENS-FRIENDLY? <>>
		<TELL
"The palisade smolders a bit, but is otherwise undamaged." CR>)
	       (<VERB? CLIMB-UP CLIMB-ON>
		<TELL
"The palisade is unclimbable." CR>)>>

<ROUTINE VILLAGE-FCN (RARG)
	 <COND (<==? .RARG ,M-BEG>
		<COND (<AND <VERB? WALK>
			    <IN? ,SPACESUIT ,CHIEF>
			    <==? ,PRSO ,P?EAST>
			    <NOT <IN? ,CHIEF ,VILLAGE>>
			    <L? ,CHFOLLOW 2>>
		       <PERFORM ,V?FOLLOW ,CHIEF>
		       <RTRUE>)
		      (<FSET? ,VIOLET-KEY ,TOUCHBIT>
		       <JIGS-UP
"Startled aliens recognize you as the desecrator of their sacred place!
They attack and overwhelm you by their sheer numbers.">)>)
	       (<==? .RARG ,M-ENTER>
		<COND (<IN? ,SPACESUIT ,VILLAGE>
		       <REMOVE ,JUNK-SPACESUIT>
		       <MOVE ,SPACESUIT ,CHIEF>)>
		<RFALSE>)>>

<ROUTINE ENTER-WARREN ()
	 <COND (,ALIENS-FRIENDLY? ,MAZE)
	       (ELSE
		<TELL
"Hostile weasels bar your way." CR>
		<RFALSE>)>>

<ROUTINE GIVE-TO-CHIEF ()
	 <COND (<==? ,PRSO ,SPACESUIT>
		<COND (,SUIT-ON? <RFALSE>)>
		<MOVE ,JUNK-SPACESUIT ,HERE>
		<FCLEAR ,JUNK-SPACESUIT ,NDESCBIT>
		<MOVE ,SPACESUIT ,CHIEF>
		<FSET ,SPACESUIT ,NDESCBIT>
		<SETG THIS-END <>>
		<SETG THAT-END <>>
		<SETG SUIT-ON? <>>
		<TELL
"The chieftain removes his suit and dons yours. He is clearly delighted with
the gift, and his people are truly impressed by his new wardrobe. He moves
about, pointing at various objects (including some of his lesser wives and
children) and glancing at you quizzically." CR>
		<ENABLE <QUEUE I-CHIEF 2>>
		<COND (,POINTED?
		       <TELL
"He tries (somewhat sheepishly) to conceal the brown rod in the space suit,
hoping you won't notice it." CR>)>
		<RTRUE>)
	       (<NOT ,ALIENS-FRIENDLY?>
		<TELL "He snarls at you, exposing razor-sharp teeth." CR>)
	       (<IN? ,SPACESUIT ,ADVENTURER>
		<TELL
"The chief refuses your gift but gazes hungrily at your space suit." CR>)
	       (<IN? ,SPACESUIT ,CHIEF>
		<TELL
"The chief considers the space suit to have been enough, and graciously
refuses the gift." CR>)
	       (ELSE
		<TELL
"The chief looks pleased by the offer (as a token of your submission, no
doubt), but turns it down." CR>)>>

<GLOBAL HUSTLED? <>>

<ROUTINE I-CHIEF-APPEARS ()
	 <COND (<==? ,HERE ,VILLAGE>
		<FCLEAR ,GLOBAL-CHIEF ,INVISIBLE>
		<MOVE ,CHIEF ,HERE>
		<TELL
"From down a passage between the hovels appears a large, almost
all-grey alien." CR>
		<COND (<IN? ,SPACESUIT ,CHIEF>
		       <TELL
"He is wearing a human space suit and grinning cheerfully." CR>)
		      (ELSE
		       <TELL
"He is dressed in the tattered remains of a space suit of alien manufacture.
Only the helmet and scraps of the body material remain." CR>)>
		<COND (<IN? ,BROWN-KEY ,CHIEF>
		       <TELL
"Around his neck hangs a brown crystal rod!" CR>)>
		<TELL "The crowd parts to let him through." CR>
		<COND (<IN? ,SPACESUIT ,ADVENTURER>
		       <TELL
"He looks at you in awe, staring at your space suit. He points to it,
and then at himself, and brandishes his spear menacingly." CR>)
		      (,ALIENS-FRIENDLY?
		       <TELL "He greets you warmly." CR>)>
		<ENABLE <QUEUE I-CHIEF 2>>)
	       (ELSE
		<COND (<NOT ,ACTIVITY?>
		       <SETG ACTIVITY? T>
		       <COND (<EQUAL? ,HERE ,VILLAGE ,VILLAGE-NW-EDGE>
			      <TELL
"There seems to be activity in the village center." CR>)>)>
		<ENABLE <QUEUE I-CHIEF-APPEARS 1>>)>>

<GLOBAL ACTIVITY? <>>

<ROUTINE DESCRIBE-WEASELS ()
	 <TELL
"They resemble human-sized weasels. Their bodies are thin, flexible, and
covered with several colors of hair. There are all sizes and ages, and the
stronger ones are armed with spears, knives, and other nasty hardware." CR>>

<ROUTINE ALIENS-FCN ()
	 <COND (<AND <IN? ,CHIEF ,HERE> <NOT <VERB? ZAP ATTACK>>>
		<COND (<==? ,ALIENS ,WINNER>
		       <SETG WINNER ,CHIEF>
		       <PERFORM ,PRSA ,PRSO ,PRSI>)
		      (<==? ,PRSO ,CHIEF>
		       <PERFORM ,PRSA ,CHIEF ,PRSI>)
		      (<==? ,PRSI ,CHIEF>
		       <PERFORM ,PRSA ,PRSO ,CHIEF>)
		      (ELSE <TELL "You are ignored." CR>)>
		<RTRUE>)
	       (<VERB? SMILE>
		<COND (,ALIENS-FRIENDLY? <TELL "It smiles back." CR>)
		      (T <TELL "It snarls at you." CR>)>)
	       (<VERB? TELL>
		<SETG P-CONT <>>
		<TELL "The aliens pay no heed." CR>)
	       (<==? ,HERE ,GRASSLAND-2>
		<COND (<G? ,HUNTER-COUNT 0>
		       <COND (<NOT <VERB? FIND EXAMINE>>
			      <SPOILED-HUNT>
			      <COND (<VERB? ZAP>
				     <CRLF>
				     <ZAP-ALIENS>
				     <TELL "The hunting party scatters." CR>)>
			      <RTRUE>)>)
		      (ELSE <TELL "There are no aliens here." CR>)>)
	       (<VERB? ZAP> <ZAP-ALIENS>)
	       (<VERB? FOLLOW> <TELL "They aren't going anywhere." CR>)
	       (<VERB? ATTACK KILL MUNG THROW>
		<SETG ALIENS-FRIENDLY? <>>
		<TELL "The weasels shy away in fright." CR>)>>

<ROUTINE ZAP-ALIENS ("OPTIONAL" (ZAP-CHIEF? <>))
	 <SETG ALIENS-FRIENDLY? <>>
	 <COND (<0? ,ZAP-CNT>
		<TELL
"Nothing happens. Emboldened, the aliens surround you." CR>)
	       (<FIRST? ,ZAP-GUN>
		<ZAP-GUN-FCN>
		<TELL "The aliens are impressed and terrified." CR>)
	       (ELSE
		<SETG ZAP-CNT <- ,ZAP-CNT 1>>
		<COND (<AND .ZAP-CHIEF? <IN? ,CHIEF ,HERE>>
		       <TELL "The chief is">
		       <DISABLE <INT I-CHIEF>>
		       <REMOVE ,CHIEF>)
		      (ELSE <TELL "Many aliens are">)>
		<TELL
" disintegrated, in the best tradition of the 1930s pulps. The remainder of
the tribe attacks you, seeking revenge. You fire the ray gun at them. ">
		<COND (<G? ,ZAP-CNT 0>
		       <TELL
"It fires " <GET ,ZAP-STRS <- ,ZAP-CNT 1>> ". Each time
many aliens are dispatched, but more appear." CR>)
		      (ELSE <TELL "Nothing happens." CR>)>
		<SETG ZAP-CNT 0>
		<JIGS-UP "Ultimately, you are overwhelmed.">)>>

<GLOBAL ZAP-STRS <TABLE "once" "twice" "three times">>

<ROUTINE CHIEF-FCN ("OPTIONAL" (RARG <>) "AUX" SUIT?)
	 <COND (<==? .RARG ,M-OBJDESC>
		<TELL "The chief alien">
		<COND (<SET SUIT? <IN? ,JUNK-SPACESUIT ,CHIEF>>
		       <TELL
", wearing a tattered space suit">)
		      (<SET SUIT? <IN? ,SPACESUIT ,CHIEF>>
		       <TELL
", wearing your space suit">)>
		<COND (<IN? ,BROWN-KEY ,CHIEF>
		       <TELL " and a brown crystal rod,">)
		      (.SUIT? <TELL ",">)>
		<TELL " is here." CR>)
	       (<VERB? FOLLOW>
		<COND (<IN? ,CHIEF ,HERE>
		       <TELL
"You can't follow him until he leaves..." CR>)
		      (<L? ,CHFOLLOW 2>
		       <SETG CHFOLLOW 0>
		       <SETG CHPATH <- ,CHPATH 1>>
		       <COND (<0? ,CHPATH>
			      <ENABLE <QUEUE I-CHIEF 1>>
			      <MOVE ,CHIEF ,GREEN-THREE>
			      <GOTO ,GREEN-THREE>)
			     (ELSE
			      <MOVE ,CHIEF ,MAZE>
			      <GOTO ,MAZE>)>)
		      (<==? ,HERE ,VILLAGE>
		       <DO-WALK ,P?EAST>
		       <RTRUE>)
		      (ELSE
		       <TELL
"You have lost track of him in the maze of twists and turns." CR>)>
		<RTRUE>)
	       (<NOT <IN? ,CHIEF ,HERE>>
		<TELL "There is no chief here." CR>)
	       (<OR <VERB? TELL HELLO>
		    <AND <==? ,CHIEF ,WINNER> <IN? ,CHIEF ,HERE>>>
		<SETG P-CONT <>>
		<TELL
"The chief listens intently, then responds in his own language, probably
saying something like \"That's Greek to me.\"" CR>)
	       (<VERB? EXAMINE>
		<TELL
"The chief is a perfect example of barbarian dignity and splendor.">
		<COND (<IN? ,SPACESUIT ,CHIEF>
		       <TELL " He is wearing your space suit with the same
dignity and aplomb which which a dandy would wear his evening clothes.">)
		      (<IN? ,BROWN-KEY ,CHIEF>
		       <TELL
" Tied around his neck with a string is a brown crystal rod.">)>
		<CRLF>)
	       (<VERB? SMILE>
		<COND (,ALIENS-FRIENDLY? <TELL "He smiles back." CR>)
		      (T <TELL "He snarls at you." CR>)>)
	       (<VERB? ZAP> <ZAP-ALIENS T>)
	       (<VERB? ATTACK MUNG>
		<SETG ALIENS-FRIENDLY? <>>
		<RFALSE>)
	       (<VERB? POINT> <TELL "The chief seems puzzled." CR>)
	       (<VERB? GIVE> <GIVE-TO-CHIEF>)>>

<GLOBAL POINTED? <>>

<ROUTINE BROWN-KEY-FCN ()
	 <COND (<IN? ,BROWN-KEY ,CHIEF>
		<COND (<AND <VERB? ZAP> <CAN-ZAP?>>
		       <PERFORM ,V?ZAP ,CHIEF>
		       <RTRUE>)
		      (<VERB? TAKE>
		       <TELL
"The chief jumps back and waves his spear at you angrily!" CR>)
		      (<VERB? POINT>
		       <SETG POINTED? T>
		       <COND (<IN? ,SPACESUIT ,CHIEF>
			      <FCLEAR ,BROWN-KEY ,NDESCBIT>
			      <SCORE-OBJ ,BROWN-KEY>
			      <MOVE ,BROWN-KEY ,ADVENTURER>
			      <SETG ALIENS-FRIENDLY? T>
			      <TELL
"The chief hesitates, understanding you all too well, then reluctantly
removes the rod from its string and hands it to you." CR>)
			     (<IN? ,SPACESUIT ,ADVENTURER>
			      <TELL
"The chief looks at you shrewdly, then points at your space suit." CR>)
			     (ELSE
			      <TELL
"The chief is offended." CR>)>)>)>>

<ROUTINE WIFE-PSEUDO ()
	 <COND (<AND <VERB? ZAP> <CAN-ZAP?>>
		<SETG ALIENS-FRIENDLY? <>>
		<TELL
"She is vaporized by the blast! Fortunately, the chief, has
many wives, and this was a lesser one." CR>)
	       (<VERB? TAKE POINT>
		<COND (<NOT <IN? ,BROWN-KEY ,CHIEF>> <RFALSE>)
		      (<IN? ,SPACESUIT ,CHIEF>
		       <TELL
"She snarls at her husband and grimaces at you. The chief waves his hands as
if to say \"Never mind.\"" CR>)>)>>

<ROUTINE CHILD-PSEUDO ()
	 <COND (<AND <VERB? ZAP> <CAN-ZAP?>>
		<SETG ALIENS-FRIENDLY? <>>
		<TELL
"The agile young weasel dodges the blast, laughing at you." CR>)
	       (<VERB? TAKE POINT>
		<COND (<NOT <IN? ,BROWN-KEY ,CHIEF>> <RFALSE>)
		      (<IN? ,SPACESUIT ,CHIEF>
		       <TELL
"The child sticks its tongue at you and scampers off. Other young weasels
caper about, making noises that sound much like laughter." CR>)>)>>

<ROUTINE MAZE-FCN (RARG)
	 <FCLEAR ,MAZE ,TOUCHBIT>
	 <COND (<IN? ,CHIEF ,VILLAGE>
		<QUEUE I-CHIEF 0>
		<REMOVE ,CHIEF>)>
	 <COND (<==? .RARG ,M-BEG>
		<COND (<AND <VERB? WALK> <PROB 5>>
		       <GOTO ,VILLAGE>)
		      (<VERB? DROP>
		       <TELL
"As soon as you drop the " D ,PRSO ", one of the smaller creatures rushes
over and grabs it! He charges out of the room, squeaking with glee." CR>
		       <COND (<PROB 25>
			      <TELL
"With a roar, an older weasel grabs the young one before it escapes and cuffs
it soundly about the ears. The elder creature hands you back the " D ,PRSO ",
grinning and grunting in a friendly way." CR>)
			     (ELSE <REMOVE ,PRSO>)>)>)
	       (<==? .RARG ,M-ENTER>
		<ROB ,HERE ,THRONE-ROOM>)>>

<GLOBAL CHFOLLOW 2>	;"can't follow him initially"
<GLOBAL CHWAIT 0>	;"how long chief waiting for trade"
<GLOBAL CHPATH 0>	;"how many moves left in maze"

<ROUTINE I-CHIEF ("AUX" (OLDP <LOC ,CHIEF>))
	 <COND (<AND <IN? ,CHIEF ,VILLAGE>
		     <IN? ,BROWN-KEY ,CHIEF>
		     <NOT <G? ,CHWAIT 10>>>
		<SETG CHWAIT <+ ,CHWAIT 1>>
		<COND (<IN? ,CHIEF ,HERE>
		       <TELL
"The chief gestures impatiently at ">
		       <COND (<OR <IN? ,SPACESUIT ,ADVENTURER>
				  <IN? ,SPACESUIT ,HERE>>
			      <TELL "your space suit.">)
			     (<IN? ,SPACESUIT ,CHIEF>
			      <TELL "various objects.">)
			     (ELSE <TELL "you.">)>
		       <CRLF>)>
		<ENABLE <QUEUE I-CHIEF 2>>
		<RTRUE>)
	       (<IN? ,CHIEF ,GREEN-THREE>
		<TELL
"The chief grins, exposing his pointy teeth, and points portentiously at
the ladder. He curls up on the dirt floor and waits, watching you with
interest." CR>
		<DISABLE <INT I-CHIEF>>
		<RTRUE>)>
	 <REMOVE ,CHIEF>
	 <SETG CHFOLLOW <+ ,CHFOLLOW 1>>
	 <COND (<G? ,CHWAIT 10> ;"chief tired of waiting"
		<COND (<IN? ,WINNER .OLDP>
		       <TELL
"The chief appears insulted and disappears into the warren. The others appear
to be upset." CR>)>
		<SETG ALIENS-FRIENDLY? <>>
		<SETG CHFOLLOW 2>
		<RTRUE> ;"chomped. don't reenable")>
	 <COND (<IN? ,WINNER .OLDP>
		<SETG CHFOLLOW 0>
	        <COND (<==? .OLDP ,VILLAGE>
		       <SETG CHPATH <+ 5 <RANDOM 5>>>)>
		<TELL <PICK-ONE ,CHIEF-MOVES> CR>)
	       (<IN? ,WINNER ,MAZE>
		<COND (<PROB 5>
		       <MOVE ,CHIEF ,MAZE>
		       <SETG CHFOLLOW 0>
		       <TELL
"The chief enters the room and seems surprised but pleased to see you." CR>)
		      (ELSE <SETG CHWAIT <+ ,CHWAIT 1>>)>)>
	 <ENABLE <QUEUE I-CHIEF
			<COND (<PROB 75> 1)(ELSE 2)>>>
	 <RTRUE>>

<GLOBAL CHIEF-MOVES <LTABLE
"The chief slips through an opening and disappears."
"Dodging several youngsters, the chief enters a hovel."
"The chief slips through a crowd, which parts deferentially."
"Glancing back at you, the chief leaves the room.">>

<ROUTINE SKELETON-FCN ()
	 <COND (<VERB? TAKE RUB MOVE>
		<COND (<FSET? ,VIOLET-KEY ,INVISIBLE>
		       <MOVE ,VIOLET-KEY ,THRONE-ROOM>
		       <FCLEAR ,VIOLET-KEY ,INVISIBLE>
		       <THIS-IS-IT ,VIOLET-KEY>
		       <TELL
"When you touch the skeleton, its arm falls off the armrest. Something
slides out of the space suit and onto the floor." CR>)
		      (ELSE
		       <SETG ALIENS-FRIENDLY? <>>
		       <JIGS-UP
"This time, the skeleton falls apart with a horrendous clatter. A head peeks
through the door. It's a weasel! He roars, and soon dozens of the aliens
surround you. The rest, alas, is too gory to describe.">)>)
	       (<AND <VERB? ZAP> <CAN-ZAP?>>
		<SETG ALIENS-FRIENDLY? <>>
		<JIGS-UP
"The skeleton is destroyed by the blast! The aliens, hearing it, rush in and
skewer you for desecrating their sacred place.">)>>

<GLOBAL CAUGHT? <>>

<ROUTINE ITS-CLOSED (OBJ)
	 <TELL "The " D .OBJ " is closed." CR>
	 <THIS-IS-IT .OBJ>
	 <RFALSE>>

<ROUTINE GREEN-LOCK-EXIT ()
	 <COND (<NOT <FSET? ,GREEN-INNER ,OPENBIT>>
		<ITS-CLOSED ,GREEN-INNER>)
	       (<FSET? ,VIOLET-KEY ,INVISIBLE> ,GREEN-THREE)
	       (,CAUGHT?
		<TELL "Outraged aliens bar your way." CR>
		<RFALSE>)
	       (ELSE
		<ALIEN-GUARDS>
		<RFALSE>)>>

<ROUTINE GREEN-THREE-FCN (RARG)
	 <COND (<==? .RARG ,M-ENTER>
		<COND (<NOT <FSET? ,VIOLET-KEY ,INVISIBLE>>
		       <ALIEN-GUARDS>
		       <RFATAL>)>)>>

<ROUTINE ALIEN-GUARDS ()
	 <SETG CAUGHT? T>
	 <SETG ALIENS-FRIENDLY? <>>
	 <REMOVE ,VIOLET-KEY>
	 <JIGS-UP
"As you re-enter the warren an alien approaches, spear in hand. Initially he
looks friendly but becomes suspicious and rushes past you into the ship. There
is a loud roar as he realizes you have desecrated the altar! Other aliens
surround you, spears at the ready.">
	 <RFATAL>>

<ROUTINE NEST-CAGE-FCN (RARG)
	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"The force projectors here aren't working, but the cage is nonetheless
inhabited by many creatures who resemble crosses between a rat and an ant.
They are multi-legged with chitinous shells and pincers around their mouths,
but they have long ratlike tails and sparse tufts of hair. Some of them are
armed with tiny spears and walk precariously on their hind legs.">
		<COND (<IN? ,NEST ,NEST-CAGE>
		       <TELL
" In one corner is a very large mud and stick nest.">
		       <COND (<FIRST? ,NEST>
			      <TELL
" The nest is constructed of all sorts of odds and ends, including ">
			      <PRINT-CONTENTS ,NEST>
			      <TELL ".">
			      <COND (<IN? ,RED-KEY ,NEST>
				     <TELL
" The rod is embedded in the mud near one of the entrances of the nest.">)>)>)
		      (<IN? ,SMASHED-NEST ,NEST-CAGE>
		       <TELL
" In one corner is a ruined nest which has been broken into many
smaller pieces.">
		       <COND (<FIRST? ,SMASHED-NEST>
			      <TELL
" Resting among the fragments of the nest can be seen ">
			      <PRINT-CONTENTS ,SMASHED-NEST>
			      <TELL ".">)>)>
		<COND (,RATS-MAD?
		       <TELL
" The rat-ants are extremely agitated by your presence, and a detail
follows you just out of reach, hissing and clicking their mandibles.">)>
		<CRLF>)>>

<GLOBAL RATS-MAD? <>>

<ROUTINE RAT-ANT-FCN ()
	 <COND (<VERB? TELL>
		<TELL "The rat-ant ignores you." CR>
		<SETG P-CONT <>>
		<RTRUE>)
	       (<VERB? EXAMINE>
		<TELL
"They look like a cross between a rat and an ant. They have chitinous shells,
mandibles, and exhibit an ant-like social order. They also have hair, bear
live young, and are roughly the size of rats. They have a crude intelligence,
evidenced by the spears of the warrior caste. The cage has many rat-ants of
varying sizes, ages, and social roles." CR>)
	       (<AND <VERB? ZAP> <CAN-ZAP?>>
		<SETG RATS-MAD? T>
		<TELL
"Several rat-ant warriors are reduced to ash, but many more rush out to
replace them, and these look mad!" CR>)
	       (<VERB? MUNG>
		<SETG RATS-MAD? T>
		<TELL
"The rat-ants become ferocious, rushing about clicking their mandibles
and squeaking." CR>)
	       (<AND <VERB? GIVE> <==? ,PRSI ,RAT-ANT>>
		<FSET ,PRSO ,NDESCBIT>
		<MOVE ,PRSO <COND (<IN? ,NEST ,HERE> ,NEST)
				  (<IN? ,SMASHED-NEST ,HERE> ,SMASHED-NEST)
				  (T
				   <TELL
"The rat-ants ignore you in their grief." CR>
				   <RTRUE>)>>
		<TELL
"A rat-ant takes the " D ,PRSO " and incorporates it into the nest." CR>)>>

<ROUTINE NEST-FCN ("AUX" (TOOL <>))
	 <COND (<VERB? EXAMINE>
		<TELL
"The nest is a jerry-built construction of odds and ends precariously stuck
together. Rat-ants swarm all over it." CR>)
	       (<VERB? KICK>
		<TELL
"Rat-ants nip at your toes and prevent it." CR>)
	       (<OR <AND <VERB? MUNG>
			 <==? ,PRSO ,NEST>
			 ,PRSI>
		    <AND <VERB? THROW>
			 <==? ,PRSI ,NEST>
			 ,PRSO>>
		<COND (<VERB? MUNG> <SET TOOL ,PRSI>)
		      (ELSE <SET TOOL ,PRSO>)>
		<COND (<==? .TOOL ,HANDS>
		       <TELL
"Rat-ants snap at you with their nasty sharp mandibles." CR>
		       <RTRUE>)
		      (<NOT <IN? .TOOL ,WINNER>>
		       <DONT-HAVE .TOOL>
		       <RTRUE>)
		      (<G? <GETP .TOOL ,P?SIZE> 5>
		       <FSET .TOOL ,NDESCBIT>
		       <MOVE .TOOL ,SMASHED-NEST>
		       <COND (<IN? ,RED-KEY ,NEST>
			      <FSET ,RED-KEY ,TOUCHBIT>
			      <FSET ,RED-KEY ,NDESCBIT>
			      <MOVE ,RED-KEY ,SMASHED-NEST>)>
		       <MOVE ,SMASHED-NEST ,NEST-CAGE>
		       <ROB ,NEST ,SMASHED-NEST T>
		       <REMOVE ,NEST>
		       <ENABLE <QUEUE I-NEST 15>>
		       <TELL
"The nest smashes into fragments and the rat-ants stop dead in their tracks!
They frantically evacuate the nest and immediately begin constructing a new
nest at the opposite end of the cage. Rat-ant babies are being carried across
the cage, and warriors watch you suspiciously." CR>)
		      (ELSE
		       <FSET .TOOL ,NDESCBIT>
		       <MOVE .TOOL ,NEST>
		       <TELL
"The " D .TOOL " doesn't damage the nest very much, and in fact a
rat-ant quickly incorporates it into the nest." CR>)>)
	       (<VERB? ZAP>
		<REMOVE ,NEST>
		<DISABLE <INT I-NEST>>
		<TELL
"The nest and all it contains is destroyed." CR>)>>

<ROUTINE I-NEST ()
	 <MOVE ,NEST ,NEST-CAGE>
	 <ROB ,SMASHED-NEST ,NEST T>
	 <ROB ,NEST-CAGE ,NEST T>
	 <REMOVE ,SMASHED-NEST>
	 <COND (<==? ,HERE ,NEST-CAGE>
		<TELL
"The rat-ants have completed their new nest, frugally incorporating all
the materials from the old nest. They leave a few guards to
watch you while the others retire inside for a well-earned rest." CR>)>>

<ROUTINE NEST-CONT ()
	 <COND (<VERB? TAKE>
		<TELL
"As you reach for the " D ,PRSO ", a rat-ant pokes its head out of the nest
and snaps at you with its needle-sharp mandibles. You draw back just in
time." CR>)>>

<ROUTINE SMASHED-NEST-CONT ()
	 <COND (<VERB? TAKE>
		<FCLEAR ,PRSO ,NDESCBIT>
		<>)>>

<GLOBAL MELTED? <>>
<GLOBAL FRIED? <>>
<GLOBAL SWITCH-ON? <>>
<GLOBAL GOT-KEY? <>>

<ROUTINE PANEL-FCN ()
	 <COND (<AND <VERB? OPEN>
		     <NOT <FSET? ,PANEL ,OPENBIT>>>
		<FSET ,PANEL ,OPENBIT>
		<TELL
"Opening the access panel reveals rack upon rack of metallic cards.">
		<COND (<IN? ,CARD ,SLOT>
		       <TELL
" All the slots have cards in them." CR>)
		      (ELSE
		       <TELL
" There is one slot that has no card in it." CR>)>)>>

<ROUTINE SLOT-FCN ()
	 <COND (<VERB? PUT>
		<COND (<==? ,PRSO ,CARD>
		       <COND (<IN? ,CARD ,SLOT>
			      <TELL "It's already there." CR>)
			     (ELSE
			      <MOVE ,CARD ,SLOT>
			      <TELL
"The card slides snugly into the slot.">
			      <COND (,SWITCH-ON?
				     <SETG FRIED? T>
				     <ENABLE <QUEUE I-MELTDOWN 2>>
				     <TELL
" Almost immediately the smell of burning components assaults your nostrils,
and smoke pours from the card.">)>
		       <CRLF>
		       <RTRUE>)>)
		      (ELSE
		       <WONT-FIT>)>)>>

<ROUTINE I-MELTDOWN ()
	 <COND (,SWITCH-ON?
		<SETG MELTED? T>
		<SETG SWITCH-ON? <>>
		<REMOVE ,CARD>
		<TELL
"The computer has now been completely fried by this electrical fire.
Congratulations!" CR>)>>

\

"SUBTITLE WEAPONS DECK AND ZAP GUN"

<GLOBAL ZAP-CNT 3>
<GLOBAL ZAP-NUMS <LTABLE "one" "two" "three" "four">>

"use CAN-ZAP? to do right thing in frobs that want to handle being zapped."

<ROUTINE CAN-ZAP? ()
	 <COND (<OR <0? ,ZAP-CNT> <IN? ,SILVER-KEY ,ZAP-GUN>>
		<RFALSE>)
	       (ELSE
		<SETG ZAP-CNT <- ,ZAP-CNT 1>>
		<RTRUE>)>>

<ROUTINE ZAP-GUN-FCN ("AUX" I)
	 <SET I <FIRST? ,ZAP-GUN>>
	 <COND (<VERB? EXAMINE>
		<TELL
"It looks like the heavy duty model. It's got quite a bit of heft to it, and
you really need two hands to aim it properly. The barrel is long and festooned
with strange knobs and antennae. There is a charge indicator which is
unfortunately unreadable." CR>)
	       (<VERB? OPEN> <TELL "You can't open that." CR>)
	       (<VERB? LOOK-INSIDE>
		<COND (.I
		       <FSET ,ZAP-GUN ,OPENBIT>
		       <TELL "In the barrel is a " D .I "!" CR>
		       <SCORE-OBJ .I>
		       <RTRUE>)
		      (ELSE <TELL "There is nothing inside the barrel." CR>)>)
	       (<AND <VERB? SHAKE> .I>
		<TELL "It rattles loudly." CR>)
	       (<AND <VERB? PUT> <==? ,ZAP-GUN ,PRSI>>
		<COND (.I <TELL "There is already something inside it." CR>)
		      (<NOT <FSET? ,PRSO ,KEYBIT>>
		       <WONT-FIT>)>)
	       (<VERB? POINT>
		<TELL "Why don't you just fire it instead?" CR>)
	       (<VERB? MUNG ATTACK>
		<TELL
"Firing the ray gun is more efficient than smashing things with it." CR>)
	       (<VERB? ZAP>
		<COND (<NOT <IN? ,ZAP-GUN ,WINNER>>
		       <TELL "You are firing it by mental force, I assume?" CR>
		       <RTRUE>)
		      (<==? ,ZAP-CNT 0>
		       <TELL "\"Click.\"" CR>
		       <RTRUE>)>
		<SETG ZAP-CNT <- ,ZAP-CNT 1>>
		<COND (.I
		       <REMOVE .I>
		       <FSET ,ZAP-GUN ,OPENBIT>
		       <COND (<NOT <0? ,ZAP-CNT>>
			      <SETG ZAP-CNT <- ,ZAP-CNT 1>>)>
		       <TELL
"A giant blast">
		       <COND (<==? .I ,SILVER-KEY>
			      <TELL " of silvery rays">)>
		       <TELL " issues from the barrel, but it doesn't
go very far. In fact, there is a secondary explosion about a foot from
the barrel, scattering dust motes in the air. There is almost no
recoil: instead the gun vibrated almost painfully. This felt like a
misfire." CR>)
		      (<FSET? ,HERE ,RAIRBIT> <JATO>)
		      (<NOT ,PRSI>
		       <TELL
"A giant blast of searing orange rays issues from the barrel, and the
recoil knocks you flat on your back. Fortunately no one was standing
in front of you or it would have been curtains." CR>)
		      (<EQUAL? ,PRSI ,ME ,HANDS>
		       <ROB ,WINNER>
		       <JIGS-UP
"If you say so... The blast destroys you and your possessions so quickly
there is no point in even describing the carnage.">)
		      (<==? ,PRSI ,ZAP-GUN>
		       <TELL
"That would involve a higher technology than even the builders of the
ray gun possessed." CR>)
		      (<FSET? ,PRSI ,VILLAIN>
		       <REMOVE ,PRSI>
		       <TELL
"A mighty wash of orange rays and smoke covers the " D ,PRSI ". The powerful
blast knocks you down as the poor " D ,PRSI " is utterly disintegrated." CR>)
		      (<IN? ,PRSI ,WINNER>
		       <ROB ,WINNER>
		       <TELL
"A huge explosion of orange rays destroys the " D ,PRSI " utterly." CR>
		       <JIGS-UP
"Unfortunately, that requires firing so close that the blast destroys
you and your possessions as well.">)
		      (<OR <FSET? ,PRSI ,TAKEBIT> <FSET? ,PRSI ,VICBIT>>
		       <REMOVE ,PRSI>
		       <TELL
"There is a horrendous explosion from the ray gun, and a huge gout of orange
rays envelops the " D ,PRSI ". You are knocked spinning by the recoil, and
when you recover, you see no sign of the " D ,PRSI " but a tiny drift of
dust." CR>)
		      (ELSE
		       <TELL
"An explosion of orange rays sweeps over the " D ,PRSI ", but when the
smoke clears, it is still there (though perhaps a bit singed)." CR>)>)
	       (<AND <VERB? KILL MUNG ATTACK>
		     <==? ,ZAP-GUN ,PRSI>>
		<PERFORM ,V?ZAP ,PRSI ,PRSO>
		<RTRUE>)>>

\

"SUBTITLE INSIDE THE CYLINDER"

<ROUTINE TREE-FCN ()
	 <COND (<VERB? CLIMB-UP CLIMB-ON CLIMB-FOO> <DO-WALK ,P?UP> <RTRUE>)
	       (<EQUAL? ,HERE ,SCRUB ,SCRUB-2> <RFALSE>)
	       (<VERB? CLIMB-DOWN> <DO-WALK ,P?DOWN> <RTRUE>)>>

<ROUTINE UP-A-TREE-EXIT ()
	 <COND (<OR <IN? ,SPACESUIT ,WINNER>
		    <IN? ,JUNK-SPACESUIT ,WINNER>>
		<TELL "You can't climb with that bulky suit." CR>
		<RFALSE>)
	       (ELSE ,UP-A-TREE)>>

<ROUTINE UP-A-TREE-FCN (RARG)
	 <COND (<==? .RARG ,M-BEG>
		<COND (<VERB? DROP THROW>
		       <MOVE ,PRSO ,BASE-OF-TREE>
		       <TELL
"The " D ,PRSO " drops out of sight." CR>)
		      (<VERB? FLY>
		       <JIGS-UP
"You aren't a bird, so you plummet rather than soar.">)
		      (<VERB? LEAP>
		       <JIGS-UP
"Gravity is low here, but not that low, so your jump is fatal.">)>)>>

<ROUTINE TREETOP-FCN (RARG)
	 <COND (<==? .RARG ,M-BEG>
		<COND (<VERB? DROP THROW>
		       <COND (<IDROP>
			      <COND (<AND <EQUAL? ,PRSO
						  ,SPACESUIT ,SAFETY-LINE>
					  <APPLY <GETP ,PRSO ,P?ACTION>>>
				     <RTRUE>)>
			      <MOVE ,PRSO ,BASE-OF-TREE>
			      <TELL
"The " D ,PRSO " drops out of sight." CR>)
			     (ELSE <RTRUE>)>)
		      (<VERB? FLY>
		       <JIGS-UP
"You aren't a bird, so you plummet rather than soar.">)
		      (<VERB? LEAP>
		       <TELL
"Gravity is almost non-existent here, so your jump easily carries
you to the hatch of the drive bubble." CR>
		       <CRLF>
		       <GOTO ,DRIVE-BUBBLE-ENTRANCE>)>)>>

<ROUTINE DRIVE-BUBBLE-ENTRANCE-FCN (RARG)
	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"You are floating (clinging?) outside the drive bubble, a crystalline
half-sphere covering the aft end of the artifact's axis of rotation.
Small knobs like handholds lead up the surface of the bubble, away from the
end of the cylinder. The drive bubble is transparent and through it you can
see the controls for the main engines of the artifact, which must be aft of
here. The only way in is a hatch which is ">
		<COND (<FSET? ,DRIVE-BUBBLE-HATCH ,OPENBIT>
		       <TELL "open.">)
		      (ELSE <TELL "closed.">)>
		<TELL " Beside the hatch is a silver slot">
		<COND (<IN? ,SILVER-KEY ,SILVER-SLOT>
		       <TELL " containing a silver rod">)>
		<TELL "." CR>)
	       (<==? .RARG ,M-BEG>
		<COND (<VERB? DROP THROW> <BOMBS-AWAY>)
		      (ELSE
		       <SWAN-DIVE ,DRIVE-BUBBLE>)>)>>

<ROUTINE SWAN-DIVE (BUB)
	 <COND (<OR <VERB? LEAP>
		    <AND <VERB? PUSH> <==? ,PRSO .BUB>>>
		<JIGS-UP
"Gravity is very light here and you practically zoom into the air.
Unfortunately gravity is not entirely non-existent, so eventually you begin
to fall, faster and faster, in a lovely curve produced by the rotation of the
artifact. You make a gorgeous but fatal swan dive into the surface.">)>>

<ROUTINE DRIVE-BUBBLE-FCN ()
	 <COND (<VERB? CLIMB-UP CLIMB-ON BOARD> <DO-WALK ,P?UP> <RTRUE>)>>

<ROUTINE CONTROL-BUBBLE-FCN ()
	 <COND (<VERB? CLIMB-UP CLIMB-ON BOARD> <DO-WALK ,P?UP> <RTRUE>)>>

<ROUTINE OUT-OF-REACH () <TELL "It's out of reach above you." CR>>

<ROUTINE DRIVE-BUBBLE-ROOM-FCN (RARG)
	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"The drive bubble is on the axis of rotation at the aft end of the artifact,
so there is no \"gravity\" here. It is transparent and you can see the tips
of the tallest trees of the forest beyond. Far off, at the opposite end of
the axis, is another bubble much like this one. ">
		<COND (<IN? ,WHITE-KEY ,WHITE-SLOT>
		       <TELL
"The room's gray walls are covered with traceries of white outlining
controls, buttons, dials, and indicators. In addition, a black slot
surrounded by an ominous dead-black circle is next to a white slot
containing a white rod.">)
		      (ELSE
		       <TELL
"The room is a featureless gray except for one small white slot.">)>
		<TELL " One way out is the hatch, which is ">
		<COND (<FSET? ,DRIVE-BUBBLE-HATCH ,OPENBIT>
		       <TELL "open.">)
		      (ELSE <TELL "closed.">)>
		<CRLF>)
	       (<==? .RARG ,M-BEG>
		<BUBBLE-BOUNCE>)>>

<ROUTINE BUBBLE-BOUNCE ()
	 <COND (<AND <VERB? WALK> <EQUAL? ,PRSO ,P?UP ,P?NORTH>>
		       <TELL
"You can't walk in that direction, as there is no gravity here. You could
jump, perhaps..." CR>)
		      (<VERB? LEAP>
		       <TELL
"You push off the floor, and because there is no weight you zoom into the air
and rebound against the transparent surface of the bubble!" CR>)>>

<ROUTINE WHITE-KEY-FCN ()
	 <COND (<AND <VERB? TAKE> <IN? ,WHITE-KEY ,WHITE-SLOT>>
		<REMOVE ,BLACK-SLOT>
		<FCLEAR ,WHITE-KEY ,NDESCBIT>
		<MOVE ,WHITE-KEY ,WINNER>
		<TELL
"When you remove the rod, the displays fade and the wall becomes
featureless gray, except for the white slot." CR>)
	       (<AND <VERB? PUT>
		     <TRYTAKE>
		     <==? ,PRSO ,WHITE-KEY>
		     <==? ,PRSI ,WHITE-SLOT>>
		<FSET ,WHITE-KEY ,TOUCHBIT>
		<FSET ,WHITE-KEY ,NDESCBIT>
		<MOVE ,BLACK-SLOT ,DRIVE-BUBBLE-ROOM>
		<MOVE ,WHITE-KEY ,WHITE-SLOT>
		<TELL
"As you insert the rod, the walls come alive with a white tracery of controls,
dials, and gauges. In addition, a black slot surrounded by an ominous
dead-black circle appears." CR>)>>

<ROUTINE ON-DRIVE-BUBBLE-FCN (RARG)
	 <COND (<==? .RARG ,M-BEG>
		<ON-BUBBLE-FCN ,DRIVE-BUBBLE ,AXIS-1>)>>

<ROUTINE SILVER-SLOT-CONT ()
	 <HATCH-CLOSE ,DRIVE-BUBBLE-HATCH>>

<ROUTINE GOLD-SLOT-CONT ()
	 <HATCH-CLOSE ,CONTROL-BUBBLE-HATCH>>

<ROUTINE HATCH-CLOSE (HATCH "AUX" CONT)
	 <COND (<VERB? TAKE>
		<SET CONT <FIRST? .HATCH>>
		<COND (<TRYTAKE>
		       <TELL
"The " D .HATCH " closes silently." CR>
		       <FCLEAR .CONT ,NDESCBIT>
		       <FCLEAR .HATCH ,OPENBIT>)>)>>

<ROUTINE SILVER-SLOT-FCN ()
	 <SLOT-DOOR ,SILVER-SLOT ,SILVER-KEY ,DRIVE-BUBBLE-HATCH>>

<ROUTINE GOLD-SLOT-FCN ()
	 <SLOT-DOOR ,GOLD-SLOT ,GOLD-KEY ,CONTROL-BUBBLE-HATCH>>

<ROUTINE SLOT-DOOR (SLOT KEY DOOR)
	 <COND (<VERB? PUT>
		<COND (<==? ,PRSO .KEY>
		       <COND (<NOT <FSET? .DOOR ,OPENBIT>>
			      <FSET .DOOR ,OPENBIT>
			      <FSET .KEY ,NDESCBIT>
			      <MOVE .KEY .SLOT>
			      <TELL
"The " D ,PRSO " slides into the slot and the " D .DOOR " opens." CR>)
			     (ELSE
			      <ALREADY "open">)>)
		      (<FSET? ,PRSO ,KEYBIT>
		       <WRONG-KEY>)
		      (ELSE
		       <WONT-FIT>)>)>>

<ROUTINE WHITE-SLOT-FCN ()
	 <COND (<VERB? PUT>
		<COND (<NOT <TRYTAKE>> <RTRUE>)
		      (<NOT <FSET? ,PRSO ,KEYBIT>>
		       <TELL "You can't do that." CR>)
		      (<==? ,PRSO ,WHITE-KEY>
		       <RFALSE>)
		      (<IN? ,WHITE-KEY ,WHITE-SLOT>
		       <TELL
"The white crystal rod is already in the slot." CR>)
		      (<FSET? ,PRSO ,KEYBIT>
		       <WRONG-KEY>)>)>>

<ROUTINE BLACK-SLOT-FCN ()
	 <COND (<VERB? PUT>
		<COND (<NOT <TRYTAKE>> <RTRUE>)
		      (<NOT <FSET? ,PRSO ,KEYBIT>>
		       <TELL "You can't do that." CR>)
		      (<==? ,PRSO ,BLACK-KEY>
		       <TELL
"As the rod slides easily into the slot, the lights go out in the bubble.
Outside, you can see dead black night settling over everything. An
expressionless voice speaks inside your head: \"Emergency shutoff mechanism
activated...\" The voice gets quieter and quieter, and finally silence rules
over all.|
">
		       <FINISH>)
		      (<FSET? ,PRSO ,KEYBIT>
		       <WRONG-KEY>)>)>>

\

<ROUTINE CONTROL-BUBBLE-ENTRANCE-FCN (RARG)
	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"You are floating outside a 100 meter crystal dome which protrudes from the
fore end of the cylinder. Inside, you can discern shadowy mechanisms and odd
constructions. Near you is an entrance which is ">
		<COND (<FSET? ,CONTROL-BUBBLE-HATCH ,OPENBIT>
		       <TELL "open.">)
		      (ELSE <TELL "closed.">)>
		<TELL
" A small slot surrounded by gold crystal is next to the hatch.">
		<COND (<IN? ,GOLD-KEY ,GOLD-SLOT>
		       <TELL " The slot contains a gold rod.">)>
		<TELL " Small knobs
which might make good handholds dot the surface of the bubble from the axis
to the hatch." CR>)
	       (<==? .RARG ,M-BEG>
		<COND (<VERB? DROP THROW> <BOMBS-AWAY>)
		      (ELSE <SWAN-DIVE ,CONTROL-BUBBLE>)>)>>

<ROUTINE CONTROL-BUBBLE-ROOM-FCN (RARG)
	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"This room must be the main control room of the artifact. The control bubble
itself is transparent and you can look out upon the interior of the artifact.
Far off, hidden among the tallest trees of the forest, is the matching drive
bubble. One way out is the hatch, which is ">
		<COND (<FSET? ,CONTROL-BUBBLE-HATCH ,OPENBIT>
		       <TELL "open.">)
		      (ELSE <TELL "closed.">)>
		<CRLF>
		<TELL "The walls are gray ">
		<COND (<IN? ,CLEAR-KEY ,CLEAR-SLOT>
		       <TELL "except for five small
color-coded slots (pink, brown, violet, green, and blue) ">
		       <COND (<IN? ,CLEAR-SLOT ,HERE>
			      <TELL "surrounding
a small clear one.">)
			     (ELSE <TELL "arranged in a pentagon.">)>)
		      (ELSE
		       <TELL "except for a single small slot
surrounded by clear crystal.">)>
		<CRLF>
		<SLOTS-AND-SPOTS>
		<COND (<IN? ,VIEW-SELECT ,HERE>
		       <APPLY <GETP ,VIEW-SELECT ,P?ACTION> ,M-OBJDESC>)>
		<RTRUE>)
	       (<==? .RARG ,M-BEG>
		<BUBBLE-BOUNCE>)>>

<ROUTINE PLANTER-FCN ()
	 <COND (<VERB? EXAMINE>
		<AS-ADVERTISED>)
	       (<VERB? DIG>
		<TELL "You find nothing of interest." CR>)>>

<ROUTINE METAL-BAND-EXIT ()
	 <COND (<NOT <FSET? ,GRASSLAND ,TOUCHBIT>>
		<ENABLE <QUEUE I-HUNTERS 2>>)>
	 <TELL
"You climb a vertical shaft for a considerable distance. The shaft opens
into a gigantic space which obviously occupies most of the interior of the
artifact. The area is " <COND (,NIGHT? "dimly")
							(T "brightly")>
						  " lit and has
an interesting geography...|
" CR>
	 ,GRASSLAND>

<GLOBAL HUNTER-COUNT 0>
<GLOBAL HUNTER-TABLE
	<LTABLE
"Weasel-like aliens in a hunting party enter the grassland."
"Weasels are stalking the unicorn herd."
"The weasels attack the herd; one straggler is confused and the weasels
converge. Speared, the unicorn falls dead."
"Weasels are butchering a unicorn."
"Weasel-like aliens are departing after a unicorn hunt.">>

<ROUTINE SEES-HUNTERS? ()
	 <OR <EQUAL? ,HERE ,GRASSLAND ,GRASSLAND-2 ,FORE-END>
	     <EQUAL? ,HERE ,METAL-BAND ,METAL-BAND-2 ,FORE-END-2>
	     <EQUAL? ,HERE ,SCRUB ,SCRUB-2>>>

<ROUTINE I-HUNTERS ()
	 <COND (<0? ,HUNTER-COUNT>
		<COND (<AND <PROB 40> <SEES-HUNTERS?>>
		       <SETG HUNTER-COUNT 1>)
	              (T <ENABLE <QUEUE I-HUNTERS 2>>)>)>
	 <COND (<NOT <0? ,HUNTER-COUNT>>
		<COND (<SEES-HUNTERS?>
		       <TELL "There is activity ">
		       <COND (<EQUAL? ,HERE ,GRASSLAND>
			      <TELL "above, across the cylinder: ">)
			     (<EQUAL? ,HERE ,GRASSLAND-2>
			      <TELL "nearby: ">)
			     (ELSE
			      <TELL
"on the grassy plain: ">)>
		       <TELL <GET ,HUNTER-TABLE ,HUNTER-COUNT> CR>)>
		<COND (<L? ,HUNTER-COUNT <GET ,HUNTER-TABLE 0>>
		       <SETG HUNTER-COUNT <+ ,HUNTER-COUNT 1>>
		       <ENABLE <QUEUE I-HUNTERS 2>>)
		      (ELSE
		       <SETG HUNTER-COUNT 0>
		       <ENABLE <QUEUE I-HUNTERS 200>>)>)>>

<ROUTINE UNICORNS-FCN ()
	 <COND (<VERB? EXAMINE>
		<COND (<==? ,HERE ,GRASSLAND>
		       <TELL
"They are over on the other side of the cylinder." CR>)
		      (T
		       <TELL
"They are nearby, cropping grass." CR>)>)
	       (<VERB? FOLLOW> <TELL "They aren't going anywhere." CR>)
	       (<VERB? ZAP>
		<COND (<CAN-ZAP?>
		       <TELL
"Many unicorns are incinerated; the rest scatter in terror, then slowly
form back into a herd some distance away." CR>
		       <SPOILED-HUNT>)>)
	       (ELSE
		<TELL
"The creatures move off as you approach, so you can't get very close to
them." CR>
		<SPOILED-HUNT>
		<RFALSE>)>>

<ROUTINE SPOILED-HUNT ()
	 <COND (<AND <G? ,HUNTER-COUNT 0>
		     <L? ,HUNTER-COUNT 4>>
		<SETG HUNTER-COUNT 0>
		<ENABLE <QUEUE I-HUNTERS 200>>
		<TELL
"You have disturbed the hunters, who are annoyed, and the unicorns, who are
now more wary. The hunt is spoiled." CR>)>
	 <RTRUE>>

<GLOBAL NIGHT? <>>

<ROUTINE I-NIGHT ()
	 <ENABLE <QUEUE I-NIGHT 128>>
	 <COND (<OR <SEES-HUNTERS?>
		    <EQUAL? ,HERE ,FOREST ,BASE-OF-TREE ,UP-A-TREE>
		    <EQUAL? ,HERE
			    ,TREETOP-ROOM ,DRIVE-BUBBLE-ENTRANCE
			    ,CONTROL-BUBBLE-ENTRANCE>
		    <EQUAL? ,HERE ,AXIS-1 ,AXIS-2 ,AXIS-3>
		    <EQUAL? ,HERE ,ON-DRIVE-BUBBLE ,ON-CONTROL-BUBBLE>>
		<COND (,NIGHT?
		       <TELL
"The lights come on: it is now full daylight." CR>)
		      (ELSE
		       <TELL
"The lights dim: it is now nighttime. There is still enough light to
see by; it's like a clear, moonlit night back on earth." CR>)>)>
		<SETG NIGHT? <NOT ,NIGHT?>>>

<ROUTINE BOMBS-AWAY ("AUX" A B)
	 <COND (<EQUAL? ,PRSO ,RED-DISK ,BLUE-DISK>
		<DISK-SWITCH ,PRSO T>)>
	 <COND (<NOT <IDROP>> <RTRUE>)
	       (<AND <EQUAL? ,PRSO ,SPACESUIT ,SAFETY-LINE>
		     <APPLY <GETP ,PRSO ,P?ACTION>>>
		<RTRUE>)
	       (<EQUAL? ,PRSI ,DRIVE-BUBBLE ,CONTROL-BUBBLE>
		<MOVE ,PRSO
		      <COND (<==? ,PRSI ,DRIVE-BUBBLE> ,FOREST)
			    (ELSE ,FORE-END)>>
		<TELL
"Throwing the " D ,PRSO " provides some impulse away from the " D ,PRSI ",
but air resistance slows you quickly." CR>)
	       (ELSE
		<COND (<EQUAL? ,HERE
			       ,ON-DRIVE-BUBBLE
			       ,DRIVE-BUBBLE-ENTRANCE>
		       <SET A ,FOREST> <SET B ,BASE-OF-TREE>)
		      (<==? ,HERE ,AXIS-1>
		       <SET A ,SCRUB> <SET B ,SCRUB-2>)
		      (<==? ,HERE ,AXIS-2>
		       <SET A ,GRASSLAND> <SET B ,GRASSLAND-2>)
		      (<==? ,HERE ,AXIS-3>
		       <SET A ,METAL-BAND> <SET B ,METAL-BAND-2>)
		      (<EQUAL? ,HERE
			       ,ON-CONTROL-BUBBLE
			       ,CONTROL-BUBBLE-ENTRANCE>
		       <SET A ,FORE-END> <SET B ,FORE-END-2>)>
		<MOVE ,PRSO <COND (<PROB 50> .A) (ELSE .B)>>
		<TELL
"The " D ,PRSO " sails away, drifting in a long arc towards the ground." CR>)>>

<ROUTINE ON-BUBBLE-FCN (BUB DEST)
	 <COND (<VERB? DROP THROW> <BOMBS-AWAY>)
	       (<OR <VERB? LEAP>
		    <AND <VERB? PUSH> <==? ,PRSO .BUB>>>
		<TELL
"You push against the surface of the bubble, and because there is no weight
here, you shoot into the air and away along the axis!" CR>
		<CRLF>
		<GOTO .DEST>
		<RTRUE>)>>

<ROUTINE ON-CONTROL-BUBBLE-FCN (RARG)
	 <COND (<==? .RARG ,M-BEG>
		<ON-BUBBLE-FCN ,CONTROL-BUBBLE ,AXIS-3>)>>

<ROUTINE AXIS-FCN ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-BEG>
		<COND (<VERB? WALK>
		       <TELL
"You are floating in midair near the axis of rotation. Given this fact,
it's hard to see how you are going to walk anywhere." CR>)
		      (<VERB? DROP THROW>
		       <BOMBS-AWAY>)
		      (<VERB? LEAP>
		       <TELL
"That was a good idea when you had something to push against. Here it
has no effect." CR>)>)>>

<ROUTINE JATO ("AUX" TARGET)
	 <SET TARGET ,PRSI>
	 <COND (<NOT <EQUAL? .TARGET ,DRIVE-BUBBLE ,CONTROL-BUBBLE ,GROUND>>
		<SET TARGET
		     <COND (<PROB 40> ,DRIVE-BUBBLE)
			   (<PROB 40> ,CONTROL-BUBBLE)
			   (ELSE ,GROUND)>>)>
	 <TELL
"A blast of orange flame issues from the gun, and the recoil propels you at
an impressive speed through the air.">
	 <COND (<EQUAL? ,HERE ,DRIVE-BUBBLE-ROOM ,CONTROL-BUBBLE-ROOM>
		<TELL
" You hit the bulkhead rather hard. Ouch!" CR>)
	       (<EQUAL? .TARGET ,DRIVE-BUBBLE ,CONTROL-BUBBLE>
		<TELL
" Eventually, air resistance slows you down, but you are still in the
weightless area near the center of the cylinder." CR>
		<COND (<==? .TARGET ,DRIVE-BUBBLE>
		       <CRLF>
		       <COND (<==? ,HERE ,ON-DRIVE-BUBBLE> <GOTO ,AXIS-1>)
			     (<==? ,HERE ,AXIS-1> <GOTO ,AXIS-2>)
			     (<==? ,HERE ,AXIS-2> <GOTO ,AXIS-3>)
			     (<==? ,HERE ,AXIS-3>
			      <GOTO ,ON-CONTROL-BUBBLE>)
			     (<==? ,HERE ,ON-CONTROL-BUBBLE>
			      <TELL
"You are still outside the control bubble." CR>)>)
		      (ELSE
		       <CRLF>
		       <COND (<==? ,HERE ,ON-DRIVE-BUBBLE>
			      <TELL
"You are still outside the drive bubble." CR>)
			     (<==? ,HERE ,AXIS-1>
			      <GOTO ,ON-DRIVE-BUBBLE>)
			     (<==? ,HERE ,AXIS-2> <GOTO ,AXIS-1>)
			     (<==? ,HERE ,AXIS-3> <GOTO ,AXIS-2>)
			     (<==? ,HERE ,ON-CONTROL-BUBBLE>
			      <GOTO ,AXIS-3>)>)>
		<RTRUE>)
	       (<==? .TARGET ,GROUND>
		<JIGS-UP
" You are now some distance from the axis of the cylinder. Air resistance and
centripetal force take hold and you start to fall in a lovely arc that ends
as you splatter against the ground.">)>>

<ROUTINE OBSERVATORY-FCN (RARG "AUX" X)
	 <COND (<==? .RARG ,M-LOOK>
		<SET X <FIRST? ,SLIDE-PROJECTOR>>
		<TELL
"This is the interior part of the artifact's observatory, with an
exit to starboard. There are no telescopes or other instruments visible">
		<COND (<OR <NOT .X> <FSET? .X ,KEYBIT>>
		       <TELL
", but in the center of the room is an image of space in the vicinity.
Examining the image, you see a tiny model of the solar system. The sun is
a bright dot in the center; Jupiter and Saturn are easily discovered.">
		       <COND (.X
			      <TELL
		      " The colors of the dots are not what you would
expect, though,">
			      <COND (<IN? ,CLEAR-KEY ,SLIDE-PROJECTOR>
				     <TELL
	       " and range throughout the spectrum.">)
				    (<FSET? .X ,KEYBIT>
				     <TELL
	       " as they are filtered through a " D .X ".">)>)>)
		      (ELSE <TELL ", only a holographic projector.">)>
		<CRLF>)>>

<ROUTINE SLIDE-PROJECTOR-FCN ("AUX" X)
	 <COND (<VERB? EXAMINE>
		<SET X <FIRST? ,SLIDE-PROJECTOR>>
		<COND (<AND .X <NOT <FSET? .X ,KEYBIT>>>
		       <TELL
"The projector is a type of laser, currently blocked by a " D .X " from
projecting any light." CR>)
		      (ELSE
		       <TELL
"The projector is a type of laser, producing a continuous holographic
view of space outside the artifact. The light issues from the front of
the projector, and is blindingly bright." CR>)>)
	       (<VERB? LOOK-SAFELY>
		<COND (<EQUAL? ,PRSI ,SMOKED-GLASS ,BLACK-KEY>
		       <TELL
"The light is very bright, but the " D ,PRSI " filters it enough so that
you are not blinded." CR>
		       <COND (<IN? ,CLEAR-KEY ,SLIDE-PROJECTOR>
			      <FCLEAR ,CLEAR-KEY ,INVISIBLE>
			      <TELL
"Inside the projector is a clear crystal rod, which has a prismatic effect
on the light being emitted." CR>)>)
		      (ELSE
		       <JIGS-UP
"The light is filtered somewhat by the rod, but not enough, and you are
blinded. You blunder about for a while, end up in a dark place, and are set
upon by grues.">)>)
	       (<VERB? LOOK-INSIDE>
		<JIGS-UP
"The light being emitted is so bright that your retina is scorched and you
are blinded. You blunder about for a while, end up in a dark place, and are
set upon by grues.">)
	       (<AND <VERB? TAKE> <IN? ,PRSO ,SLIDE-PROJECTOR>>
		<MOVE ,PRSO ,WINNER>
		<TELL "Taken. ">
		<COND (<FSET? ,PRSO ,KEYBIT>
		       <SCORE-OBJ ,PRSO>
		       <TELL
"The image displayed is now clear and correctly colored." CR>)
		      (ELSE
		       <TELL
"The displayed image becomes visible again." CR>)>)
	       (<AND <VERB? PUT> <==? ,PRSI ,SLIDE-PROJECTOR>>
		<COND (<FIRST? ,PRSI>
		       <TELL "There is already something there." CR>)
		      (<==? ,PRSO ,CLEAR-KEY>
		       <MOVE ,PRSO ,PRSI>
		       <TELL
"The displayed image is now prismatic and multi-colored." CR>)
		      (<FSET? ,PRSO ,KEYBIT>
		       <MOVE ,PRSO ,PRSI>
		       <TELL
"The displayed image is now filtered through a " D ,PRSO ", and becomes
that color." CR>)
		      (ELSE <WONT-FIT>)>)
	       (<VERB? OPEN CLOSE>
		<TELL "You can't do that to the " D ,PRSO "." CR>)>>

<ROUTINE LASER-BEAM-FCN ()
	 <COND (<VERB? EXAMINE>
		<TELL
"The beam projects a view of some outside location." CR>)
	       (<AND <VERB? ZAP> <CAN-ZAP?>>
		<TELL
"Zapping a light beam is a waste of time." CR>)
	       (<VERB? MUNG>
		<TELL
"The image vanishes while the beam is broken." CR>)>>

<ROUTINE CANT-DAMAGE ()
	 <TELL
"It's hard to see how you expect to damage a " D ,PRSO "." CR>>

<ROUTINE CONTROL-SLOT-FCN ("AUX" F)
	 <COND (<VERB? PUT>
		<COND (<OR <NOT <FSET? ,PRSO ,KEYBIT>> <FIRST? ,PRSI>>
		       <WONT-FIT>
		       <RTRUE>)
		      (<SET F <GETP ,PRSI ,P?KEY>>
		       <COND (<OR <NOT ,SWITCH-ON?>
				  <NOT <IN? ,CARD ,SLOT>>>
			      <TELL
"The " D ,PRSI " rejects the " D ,PRSO ", and the slot flashes as if
indicating a fault somewhere in the system." CR>
			      <RTRUE>)
			     (<NOT <==? ,PRSO .F>>
			      <WRONG-KEY>
			      <RTRUE>)>)>
		<MOVE ,PRSO ,PRSI>
		<FSET ,PRSO ,NDESCBIT>
		<COND (<AND <==? ,PRSO ,CLEAR-KEY>
			    <==? ,PRSI ,CLEAR-SLOT>>
		       <MOVE ,BROWN-SLOT ,HERE>
		       <MOVE ,PINK-SLOT ,HERE>
		       <MOVE ,GREEN-SLOT ,HERE>
		       <MOVE ,BLUE-SLOT ,HERE>
		       <MOVE ,VIOLET-SLOT ,HERE>
		       <MOVE ,CLEAR-KEY ,CLEAR-SLOT>
		       <TELL
"As you insert the clear rod, five other slots appear evenly ranged around
the clear one. These are colored brown, green, blue, violet and pink
respectively." CR>
		       <RTRUE>)
		      (<AND <==? ,PRSO ,BROWN-KEY>
			    <==? ,PRSI ,BROWN-SLOT>>
		       <SET F ,TARGET-SELECT>)
		      (<AND <==? ,PRSO ,PINK-KEY>
			    <==? ,PRSI ,PINK-SLOT>>
		       <SET F ,VIEW-SELECT>)
		      (<AND <==? ,PRSO ,GREEN-KEY>
			    <==? ,PRSI ,GREEN-SLOT>>
		       <SET F ,SPEED-SELECT>)
		      (<AND <==? ,PRSO ,BLUE-KEY>
			    <==? ,PRSI ,BLUE-SLOT>>
		       <SET F ,EXECUTE-BUTTON>)
		      (<AND <==? ,PRSO ,VIOLET-KEY>
			    <==? ,PRSI ,VIOLET-SLOT>>
		       <SET F ,COURSE-SELECT>)
		      (ELSE <RFALSE>)>
		<MOVE .F ,HERE>
		<TELL
"When the " D ,PRSO " is inserted into the " D ,PRSI ", a ghostly image
appears on the wall alongside it">
		<COND (<IN? ,CLEAR-SLOT ,CONTROL-BUBBLE-ROOM>
		       <REMOVE ,CLEAR-SLOT>
		       <TELL
", but the clear slot and its contents fade from view." CR>)
		      (ELSE <TELL "." CR>)>
		<COND (<EQUAL? .F ,VIEW-SELECT>
		       <PERFORM ,V?EXAMINE .F>)
		      (ELSE
		       <TELL
"The image is a " D .F " which almost seems to project out of the wall." CR>)>
		<RTRUE>)
	       (<VERB? TAKE TAKE-OFF>
		<COND (<AND <==? ,PRSO ,CLEAR-KEY>
			    <IN? ,PRSO ,CLEAR-SLOT>>
		       <SETG VIEW-STATUS 0>
		       <SETG TARGET 0>
		       <SETG COURSE-SHAPE 0>
		       <SETG SPEED-VALUE 0>
		       <REMOVE ,VIEW-SELECT>
		       <REMOVE ,TARGET-SELECT>
		       <REMOVE ,SPEED-SELECT>
		       <REMOVE ,COURSE-SELECT>
		       <REMOVE ,EXECUTE-BUTTON>
		       <REMOVE ,BROWN-SLOT>
		       <REMOVE ,PINK-SLOT>
		       <REMOVE ,GREEN-SLOT>
		       <REMOVE ,BLUE-SLOT>
		       <REMOVE ,VIOLET-SLOT>
		       <MOVE ,CLEAR-KEY ,WINNER>
		       <TELL
"When you remove the clear rod, the room returns to its original
featureless state." CR>
		       <RTRUE>)
		      (<AND <==? ,PRSO ,BROWN-KEY>
			    <IN? ,PRSO ,BROWN-SLOT>>
		       <SETG TARGET 0>
		       <SET F ,TARGET-SELECT>)
		      (<AND <==? ,PRSO ,PINK-KEY>
			    <IN? ,PRSO ,PINK-SLOT>>
		       <SETG VIEW-STATUS 0>
		       <SETG TARGET 0>
		       <SETG COURSE-SHAPE 0>
		       <SETG SPEED-VALUE 0>
		       <SET F ,VIEW-SELECT>)
		      (<AND <==? ,PRSO ,GREEN-KEY>
			    <IN? ,PRSO ,GREEN-SLOT>>
		       <SETG SPEED-VALUE 0>
		       <SET F ,SPEED-SELECT>)
		      (<AND <==? ,PRSO ,BLUE-KEY>
			    <IN? ,PRSO ,BLUE-SLOT>>
		       <SET F ,EXECUTE-BUTTON>)
		      (<AND <==? ,PRSO ,VIOLET-KEY>
			    <IN? ,PRSO ,VIOLET-SLOT>>
		       <SETG COURSE-SHAPE 0>
		       <SET F ,COURSE-SELECT>)
		      (ELSE <RFALSE>)>
		<REMOVE .F>
		<MOVE ,PRSO ,WINNER>
		<FCLEAR ,PRSO ,NDESCBIT>
		<TELL "The " D .F " fades from view as you take the " D ,PRSO>
		<COND (<OR <IN? ,BROWN-KEY ,BROWN-SLOT>
			   <IN? ,BLUE-KEY ,BLUE-SLOT>
			   <IN? ,GREEN-KEY ,GREEN-SLOT>
			   <IN? ,PINK-KEY ,PINK-SLOT>
			   <IN? ,VIOLET-KEY ,VIOLET-SLOT>>
		       <TELL "." CR>)
		      (ELSE
		       <MOVE ,CLEAR-SLOT ,CONTROL-BUBBLE-ROOM>
		       <TELL
", and a moment later the clear slot and its contents reappear." CR>)>)>>

;"This routine describes the various slots, contents, and corresponding
spots."

<ROUTINE SLOTS-AND-SPOTS ("AUX" (CNT 0) (OFF 0) SCNT TBL)
	 <COND (<NOT <IN? ,CLEAR-KEY ,CLEAR-SLOT>>
		<RTRUE>)
	       (T
		<COND (<IN? ,CLEAR-SLOT ,HERE>
		       <TELL
"A clear rod is in the clear slot. Of the surrounding slots, ">)
		      (ELSE
		       <TELL "Of the colored slots, ">)>
		<COND (<IN? ,PINK-KEY ,PINK-SLOT>
		       <TELL "the pink one contains a pink rod and ">)>
		<COND (<IN? ,BROWN-KEY ,BROWN-SLOT>
		       <SET CNT <+ .CNT 1>>)>
		<COND (<IN? ,GREEN-KEY ,GREEN-SLOT>
		       <SET CNT <+ .CNT 1>>)>
		<COND (<IN? ,BLUE-KEY ,BLUE-SLOT>
		       <SET CNT <+ .CNT 1>>)>
		<COND (<IN? ,VIOLET-KEY ,VIOLET-SLOT>
		       <SET CNT <+ .CNT 1>>)>
		<COND (<0? .CNT>
		       <COND (<IN? ,PINK-KEY ,PINK-SLOT>
			      <TELL "the others">)
			     (T
			      <TELL "all">)>
		       <TELL " are empty." CR>
		       <RTRUE>)>
		<TELL "the ">
		<SET TBL ,SLOT-TABLE>
		<SET SCNT .CNT>
		<REPEAT ()
			<COND (<0? <GET .TBL .OFF>>
			       <RETURN>)
			      (<IN? <GET .TBL .OFF> <GET .TBL <+ .OFF 1>>>
			       <TELL <GET .TBL <+ .OFF 2>>>
			       <COND (<G? .CNT 2> <TELL ", ">)
				     (<==? .CNT 2> <TELL " and ">)>
			       <COND (<L? <SET CNT <- .CNT 1>> 1>
				      <RETURN>)>)>
			<SET OFF <+ .OFF 3>>>
		<TELL " rod">
		<COND (<==? .SCNT 1>
		       <TELL " is">)
		      (T <TELL "s are">)>
		<TELL " in place in the like-colored slot">
		<COND (<==? .SCNT 1>
		       <TELL ". Alongside it is a spot">)
		      (T <TELL "s. Alongside each of those are spots">)>
		<TELL " of the same color." CR>)>>
		
<GLOBAL SLOT-TABLE
	<TABLE BLUE-KEY BLUE-SLOT "blue"
	       GREEN-KEY GREEN-SLOT "green"
	       VIOLET-KEY VIOLET-SLOT "violet"
	       BROWN-KEY BROWN-SLOT "brown"
	       0>>

<GLOBAL VIEW-STATUS 0>
<GLOBAL VIEW-SCREEN-VIEWS
	<TABLE "an empty area with a stylized depiction of the artifact itself"
	       "the inner solar system, from the sun out to Jupiter"
	       "the entire solar system, including the cometary halo"
	       "the region near the solar system, not including nearby stars"
	       "the local interstellar region, including a few nearer stars">>

<GLOBAL COURSE-SHAPE 0>
<GLOBAL TARGET 0>
<GLOBAL COURSES
	<LTABLE "in the center of "
		"in a parabola looping around "
		"in an ellipse surrounding "
		"in a circle around ">>
<GLOBAL TARGETS <LTABLE "the Sun" "Mercury" "Venus" "Earth" "Mars" "Jupiter">>
<GLOBAL SPEEDS <LTABLE "slowly" "rapidly">>
<GLOBAL SPEED-VALUE 0>

<ROUTINE VIEW-SELECT-FCN ("OPTIONAL" (RARG <>))
	 <COND (<OR <==? .RARG ,M-OBJDESC> <VERB? EXAMINE>>
		<TELL
"The pink screen includes a small square, a large square, and a display
showing nearby space. This view shows "
<GET ,VIEW-SCREEN-VIEWS ,VIEW-STATUS> ".">
		<COND (<AND <==? ,VIEW-STATUS 1>
			    <NOT <0? ,TARGET>>>
		       <TELL " The symbol representing "
			     <GET ,TARGETS ,TARGET>
			     " is lit.">
		       <COND (<NOT <0? ,COURSE-SHAPE>>
			      <TELL
" A line on the display connects the position of the artifact with
that of " <GET ,TARGETS ,TARGET> ", and terminating " <GET ,COURSES ,COURSE-SHAPE> <GET ,TARGETS ,TARGET> ".">
			      <COND (<NOT <0? ,SPEED-VALUE>>
				     <TELL " The line is made of dots,
blinking " <GET ,SPEEDS ,SPEED-VALUE> ", starting with the dot at the
artifact and ending at the one next to " <GET ,TARGETS ,TARGET> ".">)>)>)>
		<CRLF>)
	       (<VERB? RUB PUSH>
		<COND (<==? ,PRSO ,ZOOM-IN>
		       <COND (<G? ,VIEW-STATUS 0>
			      <SETG VIEW-STATUS <- ,VIEW-STATUS 1>>
			      <TELL "The view screen now shows "
				    <GET ,VIEW-SCREEN-VIEWS ,VIEW-STATUS>
				    "."
				    CR>)
			     (ELSE <TELL "The view is unchanged." CR>)>)
		      (<==? ,PRSO ,ZOOM-OUT>
		       <COND (<L? ,VIEW-STATUS 4>
			      <SETG VIEW-STATUS <+ ,VIEW-STATUS 1>>
			      <TELL "The view screen now shows "
				    <GET ,VIEW-SCREEN-VIEWS ,VIEW-STATUS>
				    "." CR>)
			     (ELSE <TELL "The view is unchanged." CR>)>)
		      (ELSE <TELL
"The display flashes briefly." CR>)>)>>

<ROUTINE TARGET-SELECT-FCN ()
	 <COND (<VERB? RUB PUSH>
		<COND (<AND <IN? ,VIEW-SELECT ,HERE>
			    <==? ,VIEW-STATUS 1>>
		       <SETG TARGET <MOD <+ ,TARGET 1> 7>>
		       <COND (<0? ,TARGET>
			      <TELL
"Now nothing is highlighted on the view screen." CR>)
			     (ELSE
			      <TELL
"The view screen now shows " <GET ,TARGETS ,TARGET> " brightly
highlighted." CR>)>)
		      (ELSE <SPOT-FLASH>)>)>>

<ROUTINE SPEED-SELECT-FCN ()
	 <COND (<VERB? RUB PUSH>
		<COND (<IN? ,VIEW-SELECT ,HERE>
		       <COND (<AND <NOT <0? ,COURSE-SHAPE>>
				   <NOT <0? ,TARGET>>>
			      <COND (<NOT <IN? ,WHITE-KEY ,WHITE-SLOT>>
				     <TELL
"The line on the display flashes brightly, insistently, for about five
seconds, and then returns to its former state." CR>
				     <RTRUE>)>
			      <SETG SPEED-VALUE <MOD <+ ,SPEED-VALUE 1> 3>>
			      <COND (<NOT <0? ,SPEED-VALUE>>
				     <TELL
"The line on the display now consists of dots which flash " <GET ,SPEEDS ,SPEED-VALUE> ", one at a time, starting with a dot at the artifact and concluding at " <GET ,TARGETS ,TARGET> "." CR>)
				    (ELSE
				     <TELL
"The line on the display is now a solid line." CR>)>)
			     (ELSE <SPOT-FLASH>)>)
		      (ELSE <SPOT-FLASH>)>)>>

<ROUTINE COURSE-SELECT-FCN ()
	 <COND (<VERB? RUB PUSH>
		<COND (<IN? ,VIEW-SELECT ,HERE>
		       <SETG COURSE-SHAPE <MOD <+ ,COURSE-SHAPE 1> 5>>
		       <COND (<NOT <0? ,TARGET>>
			      <COND (<NOT <0? ,COURSE-SHAPE>>
				     <TELL
"The highlighted image of " <GET ,TARGETS ,TARGET> " now is connected to
that of the artifact. The line terminates " <GET ,COURSES ,COURSE-SHAPE>
<GET ,TARGETS ,TARGET> "." CR>)
				    (ELSE
				     <TELL
"A line no longer connects the artifact and " <GET ,TARGETS ,TARGET> "." CR>)>)
			     (ELSE <SPOT-FLASH>)>)
		      (ELSE <SPOT-FLASH>)>)>>

<ROUTINE EXECUTE-BUTTON-FCN ("OPTIONAL" (RARG <>))
	 <COND (<VERB? PUSH RUB>
		<COND (<IN? ,VIEW-SELECT ,HERE>
		       <COND (<AND <NOT <0? ,COURSE-SHAPE>>
				   <NOT <0? ,TARGET>>
				   <NOT <0? ,SPEED-VALUE>>
				   <==? ,VIEW-STATUS 1>>
			      <COND (<G? ,CONTROL-SCORE 0>
				     <SCORE-UPD ,CONTROL-SCORE>
				     <SETG CONTROL-SCORE 0>
				     <TELL
"All the displays flash once. There is a sensation of movement
as the artifact positions itself to follow the course you have set." CR>
				     <WIN-GAME>)
				    (ELSE <SPOT-FLASH>)>)
			     (ELSE <SPOT-FLASH>)>)
		      (ELSE <SPOT-FLASH>)>)>>

<ROUTINE SPOT-FLASH () <TELL "The spot flashes briefly." CR>>

<GLOBAL CONTROL-SCORE 25>

<ROUTINE WIN-GAME ()
	 <CRLF>
	 <COND (<==? ,TARGET 4>
		<COND (<EQUAL? ,COURSE-SHAPE 3 4>
		       <SCORE-UPD 25>
		       <SETG WON-FLAG T>
		       <TELL
"The artifact, under your assured control, moves serenely toward Earth, where
the knowledge it contains will immeasureably benefit mankind. Within a few
years, there could be human ships flying out to the stars, and all because of
your daring and cunning...|
|
A holographic projection of a humanoid figure appears before you. The being,
tall and thin, swathed in shimmering robes, speaks in your own language.
\"Congratulations, you who have passed our test. You have succeeded where
others failed. Your race shall benefit thereby.\" He smiles. \"I expect to
see you in person, someday.\" The projection fades.|
" CR>)
		      (ELSE
		       <TELL
"The artifact approaches Earth, where the plaudits of humanity await you.
Unfortunately, the course you have chosen "
				 <COND (<==? ,COURSE-SHAPE 1> "rams you
into the planet and you earn the hatred of mankind, not its praises.")
      				       (ELSE "loops you
around the Earth and back into interstellar space, never to return.")>>
		       <CRLF>)>)
	       (ELSE
		<TELL
"The artifact moves confidently towards " <GET ,TARGETS ,TARGET> ",
but its computer system is smart enough to know where you came from, so
it realizes that you have made the wrong choice. All systems shut down,
and silence settles over all." CR>)>
	 <FINISH>>

<ROUTINE ON-ARTIFACT? ()
	 <COND (<OR <EQUAL? ,HERE ,SPACESHIP-BRIDGE ,SPACESHIP-STORES
			    ,SPACESHIP-QUARTERS>
		    <EQUAL? ,HERE ,SPACESHIP-AIRLOCK ,DEEP-SPACE ,RED-DOCK>
		    <EQUAL? ,HERE ,BLUE-DOCK ,YELLOW-DOCK ,GREEN-DOCK>
		    <EQUAL? ,HERE ,OUTER-SPACE>>
		<RFALSE>)
	       (ELSE <RTRUE>)>>

<ROUTINE CARD-F ()
	 <COND (<IN? ,CARD ,SLOT>
		<COND (<AND <VERB? ZAP> <CAN-ZAP?>>
		       <SETG SWITCH-ON? <>>
		       <SETG MELTED? T>
		       <RFALSE>)
		      (<AND <VERB? TAKE> ,SWITCH-ON?>
		       <TELL
			"You get a giant shock as you try to take it." CR>)>)>>

<ROUTINE ROD-RACK-FCN ()
	 <COND (<AND <VERB? TAKE> <IN? ,PRSO ,ROD-RACK>>
		<TELL
"When you take the " D ,PRSO ", the hole it was in closes up as though it
had never existed." CR>
		<MOVE ,PRSO ,WINNER>
		<RTRUE>)
	       (<AND <VERB? PUT> <==? ,PRSI ,ROD-RACK>>
		<COND (<IN? ,PRSO ,ROD-RACK>
		       <TELL "It's already there." CR>)
		      (<NOT <TRYTAKE>> <RTRUE>)
		      (<FSET? ,PRSO ,KEYBIT>
		       <MOVE ,PRSO ,ROD-RACK>
		       <SCORE-OBJ ,PRSO>
		       <TELL
"The " D ,PRSO " is inserted, and immediately another hole opens
beside it." CR>)
		      (ELSE
		       <WONT-FIT>)>)>>

<ROUTINE HATCH-DOOR-F ()
	 <COND (<VERB? OPEN CLOSE>
		<TELL "You can't manually open or close the hatch." CR>)>>

<ROUTINE SPEAR-F ("AUX" OBJ)
	 <COND (<==? ,HERE ,NEST-CAGE> <SET OBJ ,RAT-ANT>)
	       (T <SET OBJ ,ALIENS>)>
	 <COND (<VERB? TAKE>
		<TELL
"Every " D .OBJ " regards you with suspicion and won't give you a weapon." CR>)
	       (<VERB? ZAP>
		<PERFORM ,V?ZAP .OBJ>
		<RTRUE>)>>

<ROUTINE HUTS-F ()
	 <COND (<VERB? ZAP>
		<TELL "A few huts are destroyed; many remain." CR>
		<SETG ALIENS-FRIENDLY? <>>)
	       (T <EX-CHECK>)>>
	       
<ROUTINE AS-ADVERTISED ()
	 <TELL "The " D ,PRSO " is as described." CR>>

<ROUTINE WALL-F ()
	 <COND (<AND <EQUAL? ,HERE ,FORE-END ,FORE-END-2>
		     <VERB? CLIMB-FOO CLIMB-UP CLIMB-ON>>
		<TELL "The wall is unscalable!" CR>)>>

<ROUTINE DISTANT-BUBBLE-F ()
	 <COND (<VERB? LOOK-INSIDE>
		<TELL "No details are visible." CR>)
	       (ELSE
		<EX-CHECK>)>>

<ROUTINE EX-CHECK ()
	 <COND (<VERB? EXAMINE> <AS-ADVERTISED>)>>

<ROUTINE VEGGIES-F ()
	 <COND (<VERB? EAT> <TELL "Yechh!" CR>)
	       (T <EX-CHECK>)>>

<ROUTINE DRIVE-CONTROLS-F ()
	 <COND (<EX-CHECK> <RTRUE>)
	       (<VERB? ZAP> <RFALSE>)
	       (T <TELL
"You can't do anything with them." CR>)>>

<ROUTINE CAGES-F ()
	 <EX-CHECK>>

<ROUTINE TOTEMS-F ()
	 <COND (<EX-CHECK> <RTRUE>)
	       (<VERB? EAT> <VEGGIES-F>)
	       (T <TELL "It would be impolite to fool with these." CR>)>>

<ROUTINE KNOBS-F ()
	 <COND (<VERB? TAKE>
		<TELL "It is firmly attached." CR>)
	       (<VERB? REACH CLIMB-UP CLIMB-DOWN CLIMB-FOO CLIMB-ON>
		<COND (<EQUAL? ,HERE ,DRIVE-BUBBLE-ENTRANCE
			       ,CONTROL-BUBBLE-ENTRANCE>
		       <DO-WALK ,P?UP>)
		      (T <DO-WALK ,P?DOWN>)>
		<RTRUE>)>>