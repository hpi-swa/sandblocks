as yet unclassified
propagateChangeFrom: oldValue to: newValue

	self callbacksEnabled ifTrue: [ | invocation |
		lastSideEffects := {}.
		
		invocation := afterInvoke ifNotNil: [:b | b value: newValue value: self lastSideEffects].
		
		self callbacks do: [:each |
			self invokeCallback: each oldValue: oldValue newValue: newValue].
		
		invocation ifNotNil:[:i | i lastSideEffects: lastSideEffects]]