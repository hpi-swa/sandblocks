as yet unclassified
foregroundColorForBlock: aBlock

	aBlock isReturn ifTrue: [^ Color red].
	^ super foregroundColorForBlock: aBlock