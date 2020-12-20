as yet unclassified
undo

	previousClass ~= class ifTrue: [
		previousClass compile: (previousClass >> selector) getSourceFromFile.
		previousClass removeSelector: selector].
	
	previousClass organization classify: selector under: previousCategory logged: true