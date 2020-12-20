as yet unclassified
evade: aDirection
	" set this line to curve to the #left or the #right or #none "

	evade := aDirection.
	self changed.
	self layoutChanged