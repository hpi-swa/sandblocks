as yet unclassified
keyStroke: anEvent

	(anEvent keyCharacter = $v and: [anEvent commandKeyPressed]) ifTrue: [
		^ text insertString: Clipboard clipboardText].
	
	self acceptInputEvent: anEvent