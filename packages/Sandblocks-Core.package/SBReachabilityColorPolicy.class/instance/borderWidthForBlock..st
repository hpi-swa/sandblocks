as yet unclassified
borderWidthForBlock: aBlock

	^ aBlock isMessagePart ifTrue: [0] ifFalse: [1]