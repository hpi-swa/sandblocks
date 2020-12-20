actions
waitForLetterDo: aBlock

	| delay character |
	delay := Delay forMilliseconds: 50.
	[
		Sensor anyButtonPressed not and: [(character := Sensor peekKeyboard) isNil]] whileTrue: [delay wait].
	character ifNotNil: [
		character isLetter ifTrue: [aBlock value: character]]