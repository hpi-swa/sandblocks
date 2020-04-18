selection
select: aBlock

	self assert: aBlock isSandblock.
	
	(currentInput ~= nil and: [currentInput ~= aBlock]) ifTrue: [self endInput].
	
	self internalSelect: aBlock