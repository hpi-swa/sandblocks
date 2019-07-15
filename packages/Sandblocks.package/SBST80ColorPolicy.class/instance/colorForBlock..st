as yet unclassified
colorForBlock: aBlock

	^ (aBlock parentSandblock ifNotNil: #drawnColor ifNil: [Color white]) negated