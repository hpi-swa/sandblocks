as yet unclassified
replace: aBlock with: anotherBlock

	self submorphs first addMorphBack: aBlock.
	self submorphs second addMorphBack: anotherBlock