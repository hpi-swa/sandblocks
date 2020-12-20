as yet unclassified
acceptInputEvent: anEvent

	| char |
	char := anEvent keyCharacter.
	(char isAlphaNumeric or: [char = $- or: [char = $.]])
		ifTrue: [super acceptInputEvent: anEvent]
		ifFalse: [SBSmalltalkGrammarHandler new perform: char for: self empty: false]