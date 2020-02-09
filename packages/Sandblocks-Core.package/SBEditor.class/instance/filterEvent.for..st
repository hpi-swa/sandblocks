events
filterEvent: anEvent for: aMorph

	(anEvent type == #keystroke or:
	" shift-tab, for some reason is never reported on linux in keyStroke "
	[anEvent type == #keyDown and: [anEvent shiftPressed] and: [anEvent keyCharacter = Character tab]]) ifFalse: [^ anEvent].
	
	self processShortcutList: globalShortcuts for: anEvent ifMatched: [^ anEvent ignore].
	
	mode = #input ifTrue: [
		self processShortcutList: inputShortcuts for: anEvent ifMatched: [^ anEvent ignore].
		currentInput keyStroke: anEvent.
		^ anEvent ignore].
	
	mode = #command ifTrue: [self processShortcutList: commandShortcuts for: anEvent ifMatched: [^ anEvent ignore]].
	self selection ifNotNil: [
		" every single selection is also considered a single-selection, but not vice versa "
		self processShortcutList: multiSelectionShortcuts for: anEvent ifMatched: [^ anEvent ignore].
		mode ~= #selection ifTrue: [self processShortcutList: singleSelectionShortcuts for: anEvent ifMatched: [^ anEvent ignore]]].
	
	^ anEvent