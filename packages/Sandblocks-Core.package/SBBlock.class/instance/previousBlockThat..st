as yet unclassified
previousBlockThat: aBlock

	| n |
	n := self previousBlock.
	n ifNil: [^ nil].
	(aBlock value: n) ifTrue: [^ n].
	^ n previousBlockThat: aBlock