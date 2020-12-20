events
filterEvent: anEvent for: aMorph

	anEvent isMouse ifTrue: [
		anEvent isMouseDown ifTrue: [anEvent hand newKeyboardFocus: self].
		^ anEvent].
	
	anEvent isKeystroke ifFalse: [^ anEvent ignore].
	
	anEvent keyValue = 251 ifTrue: [self toggleHelperTimer: anEvent type = #keyDown] ifFalse: [self removeHelperTimer].
	
	(self performShortcutFor: anEvent)
		ifTrue: [
			inputMapping handledEvent: anEvent in: self.
			^ anEvent ignore]
		ifFalse: [inputMapping unhandledEvent: anEvent in: self didHandle: [^ anEvent ignore]].
	
	anEvent wasHandled: false.
	^ anEvent ignore