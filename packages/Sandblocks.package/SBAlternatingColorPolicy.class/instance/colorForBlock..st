as yet unclassified
colorForBlock: aBlock

	^ (aBlock parentSandblock ifNil: [^ self colors first]) drawnColor = self colors first ifTrue: [self colors second] ifFalse: [self colors first]