as yet unclassified
receiver: aBlock messages: aCollection

	self addMorphBack: aBlock.
	aCollection do: [:m | self addMorphBack: m]