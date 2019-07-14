*Sandblocks
asMessageSandblock
	
	^ SBMessageSend new
		receiver: originalReceiver asSandblock
		selector: originalSelector
		arguments: (originalArguments collect: #asSandblock);
		pc: self pc