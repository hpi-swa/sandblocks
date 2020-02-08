as yet unclassified
trackInstanceVarChange: offset

	(tempObjects includes: currentContext receiver) ifFalse: [
		self
			reportSideEffectTo: currentContext receiver
			named: (currentContext receiver class instVarNameForIndex: offset + 1)
			value: currentContext top asString]