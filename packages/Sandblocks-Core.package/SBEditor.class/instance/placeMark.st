actions
placeMark

	(self selection hasDecorator: SBMarkedDecorator)
		ifTrue: [self selection detachDecorators: SBMarkedDecorator]
		ifFalse: [
			self waitForLetterDo: [:letter |
				self selection attachDecorator: (SBMarkedDecorator new letter: letter)]]