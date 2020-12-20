as yet unclassified
foregroundColorForBlock: aBlock

	^ aBlock hasChildSandblocks ifTrue: [Color black] ifFalse: [Color gray]