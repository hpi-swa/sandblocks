as yet unclassified
useDisplay: aDisplayClass

	display ifNotNil: #delete.
	display := aDisplayClass new.
	self addMorphBack: display.
	lastValue ifNotNil: [display reportValue: lastValue]