as yet unclassified
expression: aBlock

	expression := aBlock.
	
	self removeAllMorphs.
	self addMorphBack: aBlock.
	self switchToPrintDisplay