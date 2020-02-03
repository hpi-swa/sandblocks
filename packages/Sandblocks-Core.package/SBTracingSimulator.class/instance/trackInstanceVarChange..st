as yet unclassified
trackInstanceVarChange: offset

	self flag: #fixme. " damage recorder changes are ignored for demo purposes only, but are technically valid "
	((tempObjects includes: currentContext receiver) not and: [currentContext receiver class ~~ DamageRecorder]) ifTrue: [
		self
			reportSideEffectTo: currentContext receiver
			named: (currentContext receiver class instVarNameForIndex: offset + 1)
			value: currentContext top asString]