*Sandblocks
asSandblock
	
	(originalReceiver name = 'SBWatch' and: [originalSelector == #report:for:]) ifTrue: [
		^ SBWatch new identifier: originalArguments second key; expression: originalArguments first asSandblock].
	
	(originalReceiver name = 'SBExample' and: [originalSelector == #self:args:]) ifTrue: [
		^ SBExample new self: originalArguments first statements first asSandblock args: originalArguments second statements first asSandblock].
	
	(originalReceiver name = 'Color' and: [originalSelector isUnary]) ifTrue: [ | color |
		color := Color perform: originalSelector.
		color isColor ifTrue: [^ SBColor new colorContents: color]].
	
	"(originalReceiver name = 'aUniverse' and: [originalSelector == #query:do:]) ifTrue: [
		^ ECSQuery new query: originalArguments first asSandblock block: originalArguments second asSandblock]."
	
	^ SBMessageSend new
		receiver: originalReceiver asSandblock
		selector: originalSelector
		arguments: (originalArguments collect: #asSandblock);
		pc: self pc