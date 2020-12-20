as yet unclassified
updateSelected

	| index |
	index := self activeIndex.
	
	self deselectAllBut: index.
	
	index > 0 ifTrue: [ | block |
		block := (self optionRows at: index) lastSubmorph.
		block removeLocalColorPolicy]