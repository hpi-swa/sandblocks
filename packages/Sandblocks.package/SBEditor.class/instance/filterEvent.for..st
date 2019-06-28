as yet unclassified
filterEvent: anEvent for: aMorph

	(self processGlobalShortcut: anEvent) ifTrue: [^ anEvent ignore].

	^ (selection notNil and: [anEvent type ==  #keyDown])
		ifTrue: [self processSelectionShortcut: anEvent. anEvent ignore]
		ifFalse: [anEvent]