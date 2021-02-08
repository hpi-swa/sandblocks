Class {
	#name : #SBTest,
	#superclass : #TestCase,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBTest class >> editorFor: aBlock [

	| editor |
	editor := SBEditor new useVimInput.
	editor openMorphInView: aBlock.
	aBlock select.
	^ editor
]

{ #category : #'as yet unclassified' }
SBTest class >> keyboardEvent: aCharacter [

	^ self keyboardEvent: aCharacter shift: false command: false
]

{ #category : #'as yet unclassified' }
SBTest class >> keyboardEvent: aCharacter shift: aBoolean command: anotherBoolean [

	^ KeyboardEvent new setType: #keystroke buttons: ((aBoolean ifTrue: [8] ifFalse: [0]) bitOr: (anotherBoolean ifTrue: [64] ifFalse: [0])) position: 0 @ 0 keyValue: aCharacter hand: nil stamp: nil
]

{ #category : #'as yet unclassified' }
SBTest class >> keyboardEvent: aCharacter shift: aBoolean command: anotherBoolean control: aThirdBoolean [

	^ KeyboardEvent new
		setType: #keystroke
		buttons: (((aBoolean ifTrue: [8] ifFalse: [0]) bitOr: (anotherBoolean ifTrue: [64] ifFalse: [0])) bitOr: (anotherBoolean ifTrue: [16] ifFalse: [0]))
		position: 0 @ 0
		keyValue: aCharacter
		hand: nil
		stamp: nil
]

{ #category : #'as yet unclassified' }
SBTest class >> methodFor: aBlock [

	| editor |
	editor := SBEditor new useVimInput.
	editor openMorphInView: (SBMethod new
		selector: #test arguments: #() class: nil class;
		body: (SBBlockBody new statements: {aBlock})).
	aBlock select.
	^ editor
]

{ #category : #'as yet unclassified' }
SBTest >> editorFor: aBlock [

	^ self class editorFor: aBlock
]

{ #category : #'as yet unclassified' }
SBTest >> keyboardEvent: aCharacter [

	^ self class keyboardEvent: aCharacter
]

{ #category : #'as yet unclassified' }
SBTest >> methodFor: aBlock [

	^ self class methodFor: aBlock
]
