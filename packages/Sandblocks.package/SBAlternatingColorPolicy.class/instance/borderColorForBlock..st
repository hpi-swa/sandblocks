as yet unclassified
borderColorForBlock: aBlock

	(aBlock isBlockBody and: [aBlock owner isMethod not]) ifTrue: [^ self colors third].
	^ self colors third alpha: 0.2