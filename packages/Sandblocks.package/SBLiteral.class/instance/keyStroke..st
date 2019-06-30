as yet unclassified
keyStroke: anEvent

	text keyStroke: anEvent.
	
	self contents ifEmpty: [ 
		self stopEditing.
		self replaceWithUnknown]