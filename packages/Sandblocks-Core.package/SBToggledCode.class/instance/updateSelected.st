as yet unclassified
updateSelected

	| index |
	index := self activeIndex.
	
	self deselectAllBut: index.
	
	index > 0 ifTrue: [ | block |
		block := (self submorphs at: index + 1) lastSubmorph.
		block
			setProperty: #sandblockBlockColor toValue: (block valueOfProperty: #previousBlockColor ifAbsent: [Color random]);
			changed]