as yet unclassified
expression: aBlock

	self submorphs size > 1 ifTrue: [(self submorphs at: 2) delete].
	
	self addMorphBack: aBlock