as yet unclassified
popIntoReceiverVariable: offset

	((tempObjects includes: currentContext receiver) not and: [currentContext receiver class ~~ DamageRecorder]) ifTrue: [
		sideEffects add: {currentContext receiver class instVarNameForIndex: offset + 1. currentContext receiver. SBCodeContext for: currentContext}].
	
	^ currentContext popIntoReceiverVariable: offset