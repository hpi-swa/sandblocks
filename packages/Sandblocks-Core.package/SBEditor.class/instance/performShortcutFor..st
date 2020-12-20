shortcuts
performShortcutFor: anEvent

	self shortcuts do: [:assoc |
		(assoc key matchesEvent: anEvent) ifTrue: [
			(self selection notNil and: [self perform: assoc value for: self selection event: anEvent]) ifTrue: [^ true].
			globalShortcutListeners do: [:listener |
				(self perform: assoc value for: listener event: anEvent) ifTrue: [^ true]]]].
	
	mode = #input ifTrue: [
		currentInput keyStroke: anEvent.
		^ true].
	
	^ false