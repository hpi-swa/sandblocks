*Sandblocks
asMessageSandblock

	^ SBMessageSend new
		receiver: (originalReceiver asSandblock pc: self receiver pc)"(self receiver ifNotNil: #asSandblock)"
		selector: originalSelector
		arguments: (originalArguments collect: #asSandblock);
		pc: self pc