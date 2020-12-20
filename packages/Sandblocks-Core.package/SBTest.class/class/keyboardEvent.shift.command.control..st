as yet unclassified
keyboardEvent: aCharacter shift: aBoolean command: anotherBoolean control: aThirdBoolean

	^ KeyboardEvent new
		setType: #keystroke
		buttons: (((aBoolean ifTrue: [8] ifFalse: [0]) bitOr: (anotherBoolean ifTrue: [64] ifFalse: [0])) bitOr: (anotherBoolean ifTrue: [16] ifFalse: [0]))
		position: 0 @ 0
		keyValue: aCharacter
		hand: nil
		stamp: nil