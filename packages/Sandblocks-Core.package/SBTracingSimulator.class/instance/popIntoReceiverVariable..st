as yet unclassified
popIntoReceiverVariable: offset

	self flag: #fixme. " damage recorder changes are ignored for demo purposes only, but are technically valid "
	((tempObjects includes: currentContext receiver) not and: [currentContext receiver class ~~ DamageRecorder]) ifTrue: [
		sideEffects add: {
			currentContext receiver class instVarNameForIndex: offset + 1.
			currentContext receiver.
			currentContext top asString.
			self relevantFramesFrom: currentContext}].
	
	^ currentContext popIntoReceiverVariable: offset