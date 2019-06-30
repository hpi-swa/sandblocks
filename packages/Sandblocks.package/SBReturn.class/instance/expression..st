as yet unclassified
expression: aBlock

	self submorphs size > 1 ifTrue: [self submorphs second delete].
	
	self addMorphBack: aBlock