as yet unclassified
useDisplay: aDisplay

	display ifNotNil: #delete.
	display := aDisplay.
	self addMorphBack: display