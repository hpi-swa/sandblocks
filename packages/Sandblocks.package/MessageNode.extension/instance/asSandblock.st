*Sandblocks
asSandblock
	
	(originalReceiver name = 'SBWatch' and: [originalSelector == #report:for:]) ifTrue: [
		^ SBWatch new identifier: originalArguments second key; expression: originalArguments first asSandblock].
	
	"(originalReceiver name = 'aUniverse' and: [originalSelector == #query:do:]) ifTrue: [
		^ ECSQuery new query: originalArguments first asSandblock block: originalArguments second asSandblock]."
	
	^ SBMessageSend new
		receiver: originalReceiver asSandblock
		selector: originalSelector
		arguments: (originalArguments collect: #asSandblock)