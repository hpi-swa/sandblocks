as yet unclassified
borderWidthForBlock: aBlock

	^ (aBlock isArtefact or: [(self colorForBlock: aBlock) luminance > 0.9 and: [aBlock prefersNoBorder not]]) ifTrue: [1] ifFalse: [0]