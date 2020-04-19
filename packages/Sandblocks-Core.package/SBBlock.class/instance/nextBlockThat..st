as yet unclassified
nextBlockThat: aBlock

	| n |
	n := self nextBlock.
	n ifNil: [^ nil].
	(aBlock value: n) ifTrue: [^ n].
	^ n nextBlockThat: aBlock