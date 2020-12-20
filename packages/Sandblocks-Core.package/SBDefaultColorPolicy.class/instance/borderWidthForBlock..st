as yet unclassified
borderWidthForBlock: aBlock

	^ aBlock prefersNoBorder ifTrue: [0] ifFalse: [1]