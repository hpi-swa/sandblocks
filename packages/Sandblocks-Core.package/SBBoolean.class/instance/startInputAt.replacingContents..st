as yet unclassified
startInputAt: aNumber replacingContents: aBoolean

	" ignore requests to input and instead interpret them as intent to swap the boolean "
	self toggle.
	
	^ nil