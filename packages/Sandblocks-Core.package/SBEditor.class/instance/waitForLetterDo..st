actions
waitForLetterDo: aBlock

	| delay keyEvent |
	delay := Delay forMilliseconds: 50.
	[Sensor anyButtonPressed not and: [(keyEvent := Sensor peekKeyboardEvent) isNil]]
		whileTrue: [delay wait].
	keyEvent ifNotNil: [ | letter |
		letter := (ActiveHand generateKeyboardEvent: keyEvent) keyCharacter.
		letter isLetter ifTrue: [aBlock value: letter]]