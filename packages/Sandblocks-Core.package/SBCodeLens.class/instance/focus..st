as yet unclassified
focus: aBlock

	aBlock
		ifNotNil: [
			aBlock attachDecorator: SBMarkedDecorator new.
			self applyMode: #focus]
		ifNil: [self applyMode: #expand]