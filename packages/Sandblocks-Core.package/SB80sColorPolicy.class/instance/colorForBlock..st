as yet unclassified
colorForBlock: aBlock

	aBlock isBlockBody ifTrue: [^ aBlock valueOfProperty: #sandblockBlockColor ifAbsentPut: [Color random]].
	^ (self colorForBlock: (aBlock parentSandblock ifNil: [^ Color white])) negated