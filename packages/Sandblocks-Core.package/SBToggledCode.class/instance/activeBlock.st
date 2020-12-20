as yet unclassified
activeBlock

	| index |
	index := self activeIndex.
	^ index > 0 ifTrue: [(self optionRows at: index) lastSubmorph] ifFalse: [nil]