as yet unclassified
keyStroke: anEvent

	self flag: #todo. "breaks strings"
	(anEvent keyCharacter isSpecial or: [anEvent keyCharacter = Character space]) ifTrue: [
		^ self sandblockEditor
			endInput;
			wrapInMessageSend: (anEvent keyCharacter isSpecial ifTrue: [anEvent keyCharacter asString] ifFalse: [''])].
	
	text keyStroke: anEvent.
	
	self contents ifEmpty: [ 
		self stopEditing.
		self replaceWithUnknown]