*Sandblocks
asSandblockWithoutSubstitution

	| blockReceiver |
	blockReceiver := originalReceiver asSandblock.
	" the originalReceiver may not have gotten a pc set, so we copy it from the generated receiver "
	(blockReceiver pc = 0 and: [self receiver notNil]) ifTrue: [blockReceiver pc: self receiver pc].
	
	^ SBMessageSend new
		receiver: blockReceiver
		selector: originalSelector
		arguments: (originalArguments collect: #asSandblock);
		pc: self pc