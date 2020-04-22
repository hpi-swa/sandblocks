as yet unclassified
value: aBoolean

	self firstSubmorph changeIconName: (aBoolean ifTrue: [#iconCheck_square_o] ifFalse: [#iconSquare_o]).
	value := aBoolean