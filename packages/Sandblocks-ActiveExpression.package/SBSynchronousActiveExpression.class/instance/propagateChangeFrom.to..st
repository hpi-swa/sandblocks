as yet unclassified
propagateChangeFrom: oldValue to: newValue

	self callbacksEnabled ifTrue: [ | finalCallback |
		finalCallback := nil.
		self callbacks do: [:each |
			each homeMethod methodClass = SBDisplayActiveExpression
				ifTrue: [finalCallback := each]
				ifFalse: [self invokeCallback: each oldValue: oldValue newValue: newValue]].
		" fixme: we have an implicit requirement that our display callback is evaluated last, otherwise
		  the sideeffects from the last evaluation are not yet available. deferring to the next tick would
		  mean we can't get side effects across two events during the same tick "
		finalCallback ifNotNil: [super invokeCallback: finalCallback oldValue: newValue newValue: newValue]]