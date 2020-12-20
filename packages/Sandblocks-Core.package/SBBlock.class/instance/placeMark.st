actions
placeMark
	<action>

	(self hasDecorator: SBMarkedDecorator)
		ifTrue: [self detachDecorators: SBMarkedDecorator]
		ifFalse: [
			self sandblockEditor waitForLetterDo: [:letter |
				self attachDecorator: (SBMarkedDecorator new letter: letter)]]