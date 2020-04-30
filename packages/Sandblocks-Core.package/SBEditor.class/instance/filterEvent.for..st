events
filterEvent: anEvent for: aMorph

	(anEvent type == #keystroke or: [false]) ifFalse: [^ anEvent].
	self processShortcutList: globalShortcuts for: anEvent ifMatched: [^ anEvent ignore].
	mode = #input ifTrue: [
		self processShortcutList: inputShortcuts for: anEvent ifMatched: [^ anEvent ignore].
		currentInput keyStroke: anEvent.
		^ anEvent ignore].
	mode = #command ifTrue: [self processShortcutList: commandShortcuts for: anEvent ifMatched: [^ anEvent ignore]].
	self selection ifNotNil: [
		self processShortcutList: multiSelectionShortcuts for: anEvent ifMatched: [^ anEvent ignore].
		mode ~= #selection ifTrue: [self processShortcutList: singleSelectionShortcuts for: anEvent ifMatched: [^ anEvent ignore]]].
	^ anEvent