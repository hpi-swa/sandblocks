*Sandblocks
asSandblockWithoutSubstitution

	| blockReceiver |
	blockReceiver := originalReceiver asSandblock.
	blockReceiver pc = 0 ifTrue: [blockReceiver pc: self receiver pc].
	
	^ SBMessageSend new
		receiver: blockReceiver
		selector: originalSelector
		arguments: (originalArguments collect: #asSandblock);
		pc: self pc