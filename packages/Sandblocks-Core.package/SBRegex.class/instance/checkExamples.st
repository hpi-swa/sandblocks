as yet unclassified
checkExamples

	examples submorphsDo: [:example |
		(self regexMatches: example contents)
			ifTrue: [example detachDecorators: SBErrorDecorator]
			ifFalse: [(example hasDecorator: SBErrorDecorator) ifFalse: [example attachDecorator: SBErrorDecorator new]]]