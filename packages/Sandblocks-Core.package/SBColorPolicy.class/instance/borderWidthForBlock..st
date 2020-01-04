as yet unclassified
borderWidthForBlock: aBlock

	^ aBlock isMethod ifTrue: [0] ifFalse: [1]