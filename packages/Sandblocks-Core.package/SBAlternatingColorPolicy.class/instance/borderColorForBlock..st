as yet unclassified
borderColorForBlock: aBlock

	(aBlock isBlockBody and: [aBlock owner isMethod not]) ifTrue: [^ self colors third].
	^ Color black alpha: 0.2