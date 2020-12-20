as yet unclassified
borderWidthForBlock: aBlock

	aBlock isMessagePart ifTrue: [^ 0].
	^ aBlock isBlockBody ifTrue: [1] ifFalse: [1]