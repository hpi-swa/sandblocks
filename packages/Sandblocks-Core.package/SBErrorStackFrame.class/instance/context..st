as yet unclassified
context: aContext

	context := aContext.
	self addMorph: (SBStringMorph new contents: (aContext asString truncateMiddleTo: 30))