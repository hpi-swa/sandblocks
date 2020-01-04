as yet unclassified
activeBlock

	| index |
	index := self activeIndex.
	^ index > 0 ifTrue: [(self submorphs at: index + 1) lastSubmorph] ifFalse: [nil]