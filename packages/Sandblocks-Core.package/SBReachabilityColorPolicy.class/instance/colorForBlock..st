as yet unclassified
colorForBlock: aBlock

	(aBlock containingArtefact ifNotNil: #isMethod ifNil: [false]) ifTrue: [
		^ ((self wasReached: aBlock) or: [self parentWasReached: aBlock])
				ifTrue: [Color red adjustBrightness: 0.2]
				ifFalse: [Color white]].
	^ super colorForBlock: aBlock