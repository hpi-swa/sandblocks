as yet unclassified
borderWidthForBlock: aBlock

	^ aBlock isMethod ifTrue: [1] ifFalse: [0]