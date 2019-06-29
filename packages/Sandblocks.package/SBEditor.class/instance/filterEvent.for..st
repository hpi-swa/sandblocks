as yet unclassified
filterEvent: anEvent for: aMorph


	anEvent type == #keystroke ifTrue: [
		(self processGlobalShortcut: anEvent) ifTrue: [^ anEvent ignore]].
	
	selection ifNotNil: [
		(anEvent type == #keyDown and: [anEvent shiftPressed and: [anEvent keyCharacter = Character tab]]) ifTrue: [		
			self selectPrevious.
			^ anEvent ignore].

		anEvent type ==  #keystroke
			ifTrue: [self processSelectionShortcut: anEvent. ^ anEvent ignore]].
	
	^ anEvent