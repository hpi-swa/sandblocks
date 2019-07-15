*Sandblocks
asMessageSandblock
	
	^ SBMessageSend new
		receiver: originalReceiver asSandblock"(self receiver ifNotNil: #asSandblock)"
		selector: originalSelector
		arguments: (originalArguments collect: #asSandblock);
		pc: self pc