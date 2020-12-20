as yet unclassified
colorForBlock: aBlock

	^ aBlock isBlockBody
		ifTrue: [Color white]
		ifFalse: [
			aBlock parentSandblock ifNotNil: [:p | p color adjustBrightness: -0.15] ifNil: [Color white]]