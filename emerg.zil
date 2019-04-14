"EMERG for
			   Interlogic SF Game
       (c) Copyright 1981,1982 Infocom, Inc. All Rights Reserved
"

;"Emergency lighting and environmental controls"

<ROUTINE SWITCH-FCN ()
	 <COND (<VERB? LAMP-ON TURN THROW>
		<COND (,MELTED?
		       <TELL
"There is a sickening wheeze, but nothing else happens." CR>)
		      (,SWITCH-ON?
		       <TELL "It's already on." CR>)
		      (ELSE
		       <TELL
"The lights in the room come on and there is a deafening FOOOOM! noise as the
computer starts up." CR>
		       <SETG SWITCH-ON? T>
		       <COND (<AND <IN? ,CARD ,SLOT> <NOT ,FRIED?>>
			      <COND (,GOT-KEY?
				     <TELL
"The main display blinks and displays the word \"Ready\"." CR>)
				    (ELSE
				     <SETG GOT-KEY? T>
				     <MOVE ,GOLD-KEY ,HERE>
				     <FCLEAR ,ENUNCIATOR ,INVISIBLE>
				     <TELL
"The main display blinks twice, a bell rings, and a gold rod falls from the
output hopper onto the floor! A moment later, a previously unseen enunciator
panel comes on." CR>
				     <PERFORM ,V?EXAMINE ,ENUNCIATOR>
				     <RTRUE>)>)
			     (ELSE
			      <TELL
"Lights blink on the main display and the word \"Fault\" appears." CR>)>)>)
	       (<VERB? LAMP-OFF>
		<SETG SWITCH-ON? <>>
		<FSET ,ENUNCIATOR ,INVISIBLE>
		<TELL "The computer is off." CR>)>>

<ROUTINE COMPUTER-ROOM-FCN (RARG)
	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"This is the main computer room. The builders of this ship were obviously
still wedded to large mainframes: this one fills the room and is thirty
meters high. There is an overlarge switch at about eye-level and an access
panel below it, which is ">
		<COND (<FSET? ,PANEL ,OPENBIT>
		       <TELL "open">)
		      (ELSE <TELL "closed">)>
		<TELL ". The power seems to be ">
		<COND (,SWITCH-ON? <TELL "on." CR>)
		      (ELSE <TELL "off." CR>)>
		
		<COND (,FRIED? <TELL
"There is a strong smell of burning components." CR>)>
		<RTRUE>)>>

<OBJECT ENUNCIATOR
	(IN COMPUTER-ROOM)
	(DESC "enunciator panel")
	(LDESC "An enunciator panel is prominent along one wall here.")
	(SYNONYM PANEL LIGHT LIGHTS SYMBOL)
	(ADJECTIVE ENUNCIATOR RED YELLOW BLUE GREEN)
	(FLAGS INVISIBLE)
	(ACTION ENUNCIATOR-F)>

<ROUTINE ENUNCIATOR-F ()
	 <COND (<VERB? EXAMINE>
		<COND (,SWITCH-ON?
		       <TELL
"The panel has three banks of four colored lights: red, yellow, green, and
blue. The first is labelled with a symbol of the emission of rays: of the
lights underneath, the red one is flashing and the yellow one is brightly
lit. The second bank is labelled with a stylized docking port and the third
with an airlock. Of these two banks, the first yellow one is brightly lit and
the other yellow one is flashing. The panel also contains six other lights,
each bearing a stylized picture. The first four, all dark, represent
navigation, engine, library, and defenses. A fifth, picturing a cage, is
brightly lit. The sixth is "
<GET ,AIR-FLASH ,AIR-COUNT> ". It" ,REPAIR-PANEL CR>)
		      (ELSE <TELL "The panel is dark." CR>)>)>>

<GLOBAL AIR-FLASH <TABLE
"flickering dimly"
"flashing slowly"
"flashing rapidly"
"also brightly lit"
"also brightly lit">>

<GLOBAL REPAIR-PANEL
" bears a symbol in three parts: the first two parts, in black, are a
solid block and a fluid level. The third, in red, is a series of parallel
wavy lines.">

<ROOM REPAIR-ROOM
      (IN ROOMS)
      (DESC "Repair Room")
      (OUT TO SCRUB IF METAL-DOOR IS OPEN)
      (UP TO SCRUB IF METAL-DOOR IS OPEN)
      (ACTION REPAIR-ROOM-FCN)
      (FLAGS RLANDBIT ONBIT)
      (GLOBAL STAIRS METAL-DOOR)>

<ROUTINE REPAIR-ROOM-FCN (RARG)
	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"This room is taken up by two large pieces of machinery. The leftmost has a
symbol depicting the emission of rays beside a yellow slot. The other
machine" ,REPAIR-PANEL " Beside it are three diagrams; under each one is a
red slot. The first diagram shows four single dots equally spaced around a
six-dot cluster. The second shows two eight-dot clusters in close proximity.
The third has three single dots equally spaced around a seven-dot cluster.
The only exit is up some stairs." CR>)>>

<OBJECT YELLOW-SLOT
	(IN REPAIR-ROOM)
	(DESC "yellow slot")
	(SYNONYM SLOT HOLE)
	(ADJECTIVE YELLOW)
	(FLAGS NDESCBIT CONTBIT OPENBIT)
	(KEY TO YELLOW-KEY)
	(CAPACITY 6)
	(ACTION YELLOW-SLOT-F)>

<ROUTINE YELLOW-SLOT-F ()
	 <COND (<AND <VERB? PUT> <==? ,PRSI ,YELLOW-SLOT>>
		<COND (<==? ,PRSO ,YELLOW-KEY>
		       <SETG ALWAYS-LIT T>
		       <RIGHT-KEY>
		       <CRLF>)
		      (<FSET? ,PRSO ,KEYBIT> <WRONG-KEY>)
		      (ELSE <WONT-FIT>)>)>>

<ROUTINE WONT-FIT ()
	 <TELL "The " D ,PRSO " doesn't fit in the " D ,PRSI "." CR>>

<OBJECT RED-SLOT
	(IN REPAIR-ROOM)
	(DESC "red slot")
	(SYNONYM SLOT HOLE)
	(ADJECTIVE RED FIRST SECOND THIRD)
	(FLAGS NDESCBIT CONTBIT OPENBIT)
	(KEY TO RED-KEY)
	(CAPACITY 5)
	(ACTION RED-SLOT-F)>

<ROUTINE RED-SLOT-F ("AUX" NUM)
	 <COND (<AND <VERB? PUT> <==? ,PRSI ,RED-SLOT>>
		<SET NUM <ORDINAL ,P-ADJECTIVE>>
		<COND (<OR <G? .NUM 3> <EQUAL? .NUM 0>>
		       <TELL "You must specify which red slot." CR>)
		      (<NOT <==? ,PRSO ,RED-KEY>>
		       <WRONG-KEY>)
		      (T
		       <REMOVE ,RED-KEY>
		       <RIGHT-KEY>
		       <TELL
" You hear a subdued hum of machinery coming to life." CR>
		       <COND (<==? .NUM 2>
			      <ENABLE <QUEUE I-FRESH-AIR 30>>
			      <DISABLE <INT I-BAD-AIR>>)
			     (T
			      <ENABLE <QUEUE I-POISON-AIR 20>>
			      <DISABLE <INT I-BAD-AIR>>
			      <COND (<==? .NUM 3>
				     <SETG AMMONIA? T>)>
			      <RTRUE>)>)>)>>

<ROUTINE RIGHT-KEY ()
	 <REMOVE ,PRSO>
	 <TELL
"The " D ,PRSO " disappears into the slot.">>

<ROUTINE WRONG-KEY ()
	 <REMOVE ,PRSO>
	 <TELL
"The " D ,PRSO " slides into the slot and disappears." CR>>

<ROUTINE I-FRESH-AIR ()
	 <SETG POISON-COUNT 0>
	 <COND (<0? ,AIR-COUNT> <RTRUE>)
	       (<L? <SETG AIR-COUNT <- ,AIR-COUNT 1>> 1>
		<COND (<AND <NOT ,SUIT-ON?> ,IN-ARTIFACT?>
		       <TELL
"The air seems fine now." CR>)>
		<RTRUE>)>
	 <COND (<AND <NOT ,SUIT-ON?> ,IN-ARTIFACT?>
		<DESCRIBE-AIR 
"The air seems a bit better, but is still ">)>
	 <QUEUE I-FRESH-AIR 20>>

<GLOBAL POISON-COUNT 0>

<ROUTINE I-POISON-AIR ()
	 <COND (<G? <SETG POISON-COUNT <+ ,POISON-COUNT 1>> 3>
		<COND (<NOT ,IN-ARTIFACT?>
		       <ENABLE <QUEUE I-POISON-AIR 1>>)
		      (,SUIT-ON?
		       <JIGS-UP ,STUPID-AIRGONE-MESSAGE>)
		      (T <JIGS-UP
"You are overcome by noxious gases and slump to the floor, dead.">)>)
	       (T
		<COND (<AND <NOT ,SUIT-ON?> ,IN-ARTIFACT?>
		       <DESCRIBE-AIR "The air here has become ">)>
		<QUEUE I-POISON-AIR 30>)>>

<GLOBAL STUPID-AIRGONE-MESSAGE 
"Suddenly, everything begins going dark, as though the artifact was
shutting down. A thrumming vibration stops; one you didn't even notice
until it ceased.">

<ROUTINE I-BAD-AIR ()
	 <COND (<G? <SETG AIR-COUNT <+ ,AIR-COUNT 1>> 3>
		<SETG POISON-COUNT 4>
		<COND (<NOT ,IN-ARTIFACT?>
		       <ENABLE <QUEUE I-BAD-AIR 1>>)
		      (<NOT ,SUIT-ON?>
		       <JIGS-UP
"You gasp for air, but there is none left, and slump to the floor, dead.">)
		      (T
		       <JIGS-UP ,STUPID-AIRGONE-MESSAGE>)>)
	       (T
		<COND (<AND <NOT ,SUIT-ON?> ,IN-ARTIFACT?>
		       <DESCRIBE-AIR "You notice that the air has become ">)>
		<QUEUE I-BAD-AIR 40>)>>

<GLOBAL AIR-COUNT 0>

<ROUTINE DESCRIBE-AIR (STR)
	 <COND (<==? ,POISON-COUNT 4>
		<COND (<==? ,AIR-COUNT 4>
		       <JIGS-UP
"You gasp for air, but there is none left, and slump to the floor, dead.">)
		      (T
		       <JIGS-UP
"You are overcome by noxious gases and slump to the floor, dead.">)>)
	       (<G? ,POISON-COUNT 0>
		<TELL .STR
		      <GET ,POISON-AIRS ,POISON-COUNT>
		      <GET <COND (,AMMONIA? ,AMMONIA-TABLE)
			         (T ,METHANE-TABLE)>
			   ,POISON-COUNT>
		      CR>)
	       (T
		<TELL .STR <GET ,LIGHT-AIRS ,AIR-COUNT> CR>)>>

<GLOBAL AMMONIA-TABLE <TABLE
"foo"
"glass cleaner."
"ammonia."
"ammonia.">>

<GLOBAL METHANE-TABLE <TABLE
"foo"
"charcoal."
"coal gas."
"coal gas.">>

<GLOBAL AMMONIA? <>>

<GLOBAL POISON-AIRS <TABLE
"foo"
"quite pungent, smelling vaguely of "
"quite hard to breathe, permeated with the smell of "
"almost unbreathable, and heavy with the smell of ">>

<GLOBAL LIGHT-AIRS <TABLE
"quite breathable and slightly sweet."
"quite thin."
"quite hard to breathe."
"almost unbreathable.">>