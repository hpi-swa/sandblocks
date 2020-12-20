as yet unclassified
keyStroke: anEvent

	(anEvent keyCharacter = $v and: [anEvent commandKeyPressed]) ifTrue: [
		^ text insertString: Clipboard clipboardText].
	
	(anEvent keyCharacter = Character backspace and: [self contents isEmpty]) ifTrue: [
		^ self replaceWithUnknown].
	
	self acceptInputEvent: anEvent