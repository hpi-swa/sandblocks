as yet unclassified
acceptInputEvent: anEvent

	| char |
	char := anEvent keyCharacter.
	(char isAlphaNumeric or: [char = $_])
		ifTrue: [super acceptInputEvent: anEvent]
		ifFalse: [
			self isExpression ifTrue: [SBSmalltalkGrammarHandler new perform: char for: self empty: false]]