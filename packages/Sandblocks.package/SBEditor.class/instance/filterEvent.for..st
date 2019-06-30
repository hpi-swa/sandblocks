events
filterEvent: anEvent for: aMorph

	(anEvent type == #keystroke or:
	" shift-tab, for some reason is never reported on linux in keyStroke "
	[anEvent type == #keyDown and: [anEvent shiftPressed] and: [anEvent keyCharacter = Character tab]]) ifFalse: [^ anEvent].
	
	currentInput ifNotNil: [
		anEvent keyCharacter = Character escape
			ifTrue: [self endInput]
			ifFalse: [currentInput keyStroke: anEvent].
		^ anEvent ignore].
		
	(self processGlobalShortcut: anEvent) ifTrue: [^ anEvent ignore].
	
	selection ifNotNil: [		
		self processSelectionShortcut: anEvent.
		^ anEvent ignore].
	
	^ anEvent