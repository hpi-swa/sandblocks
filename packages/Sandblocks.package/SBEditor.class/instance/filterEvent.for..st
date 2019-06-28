as yet unclassified
filterEvent: anEvent for: aMorph

	anEvent type == #keystroke ifTrue: [
		(self processGlobalShortcut: anEvent) ifTrue: [^ anEvent ignore]].
	
	^ (selection notNil and: [anEvent type ==  #keyDown])
		ifTrue: [self processSelectionShortcut: anEvent. anEvent ignore]
		ifFalse: [anEvent]