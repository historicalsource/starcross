"CRUFTY2 for
		      Zork: The Wizard of Frobozz
		 The Great Underground Empire (Part 2)
	(c) Copyright 1981 Infocom, Inc.  All Rights Reserved.
"

<ROUTINE THIS-IT? (OBJ TBL "AUX" SYNS) 
	#DECL ((OBJ) OBJECT (TBL) TABLE (SYNS) <OR FALSE TABLE>)
	<AND <NOT <FSET? .OBJ ,INVISIBLE>>
	     <OR <NOT ,P-NAM>
		 <ZMEMQ ,P-NAM
			<SET SYNS <GETPT .OBJ ,P?SYNONYM>>
			<- </ <PTSIZE .SYNS> 2> 1>>>
	     <OR <NOT ,P-ADJ>
		 <AND <SET SYNS <GETPT .OBJ ,P?ADJECTIVE>>
		      <ZMEMQB ,P-ADJ .SYNS <- <PTSIZE .SYNS> 1>>>>
	     <OR <0? ,P-GWIMBIT> <FSET? .OBJ ,P-GWIMBIT>>>>
