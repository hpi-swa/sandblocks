*Sandblocks
asSandblock
	
	(originalReceiver name = 'SBWatch' and: [originalSelector == #report:for:]) ifTrue: [
		^ SBWatch new identifier: originalArguments second key; expression: originalArguments first asSandblock].
	
	^ SBMessageSend new
		receiver: originalReceiver asSandblock
		selector: originalSelector
		arguments: (originalArguments collect: #asSandblock)