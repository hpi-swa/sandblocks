as yet unclassified
isInActiveBlockBody: aBlock

	| block |
	block := aBlock containingBlock.
	[block] whileNotNil: [
		block = self activeBlock ifTrue: [^ true].
		block := block containingBlock].
	
	^ false