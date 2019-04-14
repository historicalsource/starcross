
"MAIN for
			      Zork SF Game
	(c) Copyright 1981 Infocom, Inc.  All Rights Reserved.
"

<GLOBAL P-WON <>>

<CONSTANT M-FATAL 2>
 
<CONSTANT M-HANDLED 1>   
 
<CONSTANT M-NOT-HANDLED <>>   
 
<CONSTANT M-BEG 1>  
 
<CONSTANT M-END <>> 
 
<CONSTANT M-ENTER 2>
 
<CONSTANT M-LOOK 3> 
 
<CONSTANT M-FLASH 4>

<CONSTANT M-OBJDESC 5>

<ROUTINE GO () 
;"put interrupts on clock chain"
	 ;<QUEUE I-LAMP 200>
	 <ENABLE <QUEUE I-NIGHT 128>>
	 <ENABLE <QUEUE I-ALARM 1>>
;"set up and go"
	 <SETG LIT T>
	 <SETG WINNER ,ADVENTURER>
	 <SETG HERE ,SPACESHIP-QUARTERS>
	 <MOVE ,ADVENTURER ,BUNK>
	 <SETG FF-HERE ,FORCE-FIELD-2>
	 <PUT ,MASSES 1 ,UM08>
	 <PUT ,MASSES 2 ,UM12>
	 <PUT ,MASSES 3 ,UM24>
	 <PUT ,MASSES 4 ,UM28>
	 <PUT ,MASSES 5 ,UM31>
	 <PUT ,MASSES 6 ,UM52>
	 <PUT ,MASSES 7 ,UM70>
	 <PUT ,MASSES 8 ,UM91>
	 <PUT ,KNOWNS 1 ,AB40>
	 <PUT ,KNOWNS 2 ,AX87>
	 <PUT ,KNOWNS 3 ,AX32>
	 <PUT ,KNOWNS 4 ,AX01>
	 <PUT ,KNOWNS 5 ,AX71>
	 <PUT ,KNOWNS 6 ,US75>
	 <PUT ,KNOWNS 7 ,MARS>
	 <SETG P-IT-LOC ,HERE>
	 <SETG P-IT-OBJECT <>>
	 <COND (<NOT <FSET? ,HERE ,TOUCHBIT>>
		<V-VERSION>
		<CRLF>
		<TELL
"You are sound asleep in your bunk aboard the deep-space black hole
prospecting ship \"Starcross,\" operating out of Ceres. Just as your
sleep becomes deep and comfortable, an alarm bell begins ringing! It's
the mass detector! Instantly you awake. This hasn't been a profitable
trip so far, and you don't even have the cash for repairs. This could
be the break you've been waiting for.
|" CR>)>
	 <V-LOOK>
	 <MAIN-LOOP>
	 <AGAIN>>    


<ROUTINE MAIN-LOOP ("AUX" ICNT OCNT NUM CNT OBJ TBL V PTBL OBJ1 TMP) 
   #DECL ((CNT OCNT ICNT NUM) FIX (V) <OR 'T FIX FALSE> (OBJ) <OR FALSE OBJECT>
	  (OBJ1) OBJECT (TBL) TABLE (PTBL) <OR FALSE ATOM>)
   <REPEAT ()
     <SET CNT 0>
     <SET OBJ <>>
     <SET PTBL T>
     <COND (<SETG P-WON <PARSER>>
	    <SET ICNT <GET ,P-PRSI ,P-MATCHLEN>>
	    <SET NUM
		 <COND (<0? <SET OCNT <GET ,P-PRSO ,P-MATCHLEN>>> .OCNT)
		       (<G? .OCNT 1>
			<SET TBL ,P-PRSO>
			<COND (<0? .ICNT> <SET OBJ <>>)
			      (T <SET OBJ <GET ,P-PRSI 1>>)>
			.OCNT)
		       (<G? .ICNT 1>
			<SET PTBL <>>
			<SET TBL ,P-PRSI>
			<SET OBJ <GET ,P-PRSO 1>>
			.ICNT)
		       (T 1)>>
	    <COND (<AND <NOT .OBJ> <1? .ICNT>> <SET OBJ <GET ,P-PRSI 1>>)>
	    <COND (<==? ,PRSA ,V?WALK> <SET V <PERFORM ,PRSA ,PRSO>>)
		  (<0? .NUM>
		   <COND (<0? <BAND <GETB ,P-SYNTAX ,P-SBITS> ,P-SONUMS>>
			  <SET V <PERFORM ,PRSA>>
			  <SETG PRSO <>>)
			 (T
			  <TELL "There isn't anything to ">
			  <SET TMP <GET ,P-ITBL ,P-VERBN>>
			  <COND (,P-OFLAG
				 <PRINTB <GET .TMP 0>>)
				(T
				 <WORD-PRINT <GETB .TMP 2> <GETB .TMP 3>>)>
			  <TELL "!" CR>
			  <SET V <>>)>)
		  (T
		   <REPEAT ()
			   <COND (<G? <SET CNT <+ .CNT 1>> .NUM> <RETURN>)
				 (T
				  <COND (.PTBL <SET OBJ1 <GET ,P-PRSO .CNT>>)
					(T <SET OBJ1 <GET ,P-PRSI .CNT>>)>
				  <COND (<G? .NUM 1>
					 <PRINTD .OBJ1>
					 <TELL ": ">)>
				  <SETG PRSO <COND (.PTBL .OBJ1) (T .OBJ)>>
				  <SETG PRSI <COND (.PTBL .OBJ) (T .OBJ1)>>
				  <SET V <PERFORM ,PRSA ,PRSO ,PRSI>>
				  <COND (<==? .V ,M-FATAL> <RETURN>)>)>>)>
	    <COND (<NOT <==? ,PRSA ,V?AGAIN>>
		   <SETG L-PRSA ,PRSA>
		   <SETG L-PRSO ,PRSO>
		   <SETG L-PRSI ,PRSI>)>
	    <SETG MOVES <+ ,MOVES 1>>
	    <COND (<==? .V ,M-FATAL> <SETG P-CONT <>>)>)
	   (T
	    <SETG P-CONT <>>)>
     <COND (,P-WON
	    <COND (<VERB? TELL BRIEF SUPER-BRIEF VERBOSE SAVE SCORE> T)
		  (T <SET V <CLOCKER>>)>)>>>
 
<GLOBAL L-PRSA <>>  
 
<GLOBAL L-PRSO <>>  
 
<GLOBAL L-PRSI <>>  

<ROUTINE PERFORM (A "OPTIONAL" (O <>) (I <>) "AUX" V OA OO OI) 
	#DECL ((A) FIX (O) <OR FALSE OBJECT FIX> (I) <OR FALSE OBJECT> (V) ANY)
	<SET OA ,PRSA>
	<SET OO ,PRSO>
	<SET OI ,PRSI>
	<COND (<AND <EQUAL? ,IT .I .O>
		    <NOT <EQUAL? ,P-IT-LOC ,HERE>>>
	       <TELL "I don't see what you are referring to." CR>
	       <RFATAL>)>
	<COND (<==? .O ,IT> <SET O ,P-IT-OBJECT>)>
	<COND (<==? .I ,IT> <SET I ,P-IT-OBJECT>)>
	<SETG PRSA .A>
	<SETG PRSO .O>
	<COND (<AND ,PRSO <NOT <VERB? WALK>>>
	       <SETG P-IT-OBJECT ,PRSO>
	       <SETG P-IT-LOC ,HERE>)>
	<SETG PRSI .I>
	<COND (<SET V <APPLY <GETP ,WINNER ,P?ACTION>>> .V)
	      (<SET V <APPLY <GETP <LOC ,WINNER> ,P?ACTION> ,M-BEG>> .V)
	      (<SET V <APPLY <GET ,PREACTIONS .A>>> .V)
	      (<AND .I <SET V <APPLY <GETP .I ,P?ACTION>>>> .V)
	      (<AND .O
		    <NOT <==? .A ,V?WALK>>
		    <LOC .O>
		    <SET V <APPLY <GETP <LOC .O> ,P?CONTFCN>>>>
	       .V)
	      (<AND .O
		    <NOT <==? .A ,V?WALK>>
		    <SET V <APPLY <GETP .O ,P?ACTION>>>>
	       .V)
	      (<SET V <APPLY <GET ,ACTIONS .A>>> .V)>
	<COND (<NOT <==? .V ,M-FATAL>>
	       <SET V <APPLY <GETP <LOC ,WINNER> ,P?ACTION> ,M-END>>)>
	<SETG PRSA .OA>
	<SETG PRSO .OO>
	<SETG PRSI .OI>
	.V>  
 
