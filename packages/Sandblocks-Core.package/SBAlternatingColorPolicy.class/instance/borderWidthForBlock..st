as yet unclassified
borderWidthForBlock: aBlock

	^ aBlock isBlockBody ifTrue: [1] ifFalse: [1]