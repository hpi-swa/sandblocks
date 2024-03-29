Class {
	#name : #SBTest,
	#superclass : #TestCase,
	#instVars : [
		'world'
	],
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBTest class >> dropAt: aPoint with: aBlock in: anEditor [

	| event |
	event := MouseEvent new
		setType: #mouseMove
		position: aPoint
		buttons: MouseEvent blueButton
		hand: (HandMorph new addMorph: (SBDragContainer new addMorphBack: aBlock)).
	^ (SBDragHelper for: event in: anEditor)
		mouseMove: event;
		applyHintAt: event
]

{ #category : #'as yet unclassified' }
SBTest class >> editorFor: aBlock [

	| editor |
	editor := SBEditor new.
	editor openMorphInView: aBlock.
	aBlock ensureLayouted.
	aBlock select.
	^ editor
]

{ #category : #'as yet unclassified' }
SBTest class >> keyboardEvent: aCharacter [

	^ self keyboardEvent: aCharacter shift: false command: false
]

{ #category : #'as yet unclassified' }
SBTest class >> keyboardEvent: aCharacter shift: aBoolean command: anotherBoolean [

	^ KeyboardEvent new
		setType: #keystroke
		buttons: ((aBoolean ifTrue: [8] ifFalse: [0]) bitOr: (anotherBoolean ifTrue: [64] ifFalse: [0]))
		position: 0 @ 0
		keyValue: aCharacter
		hand: ActiveHand
		stamp: nil
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
	editor openMorphInView: (SBStMethod new
		selector: #test arguments: #() class: nil class;
		body: (SBStBlockBody new statements: {aBlock})).
	aBlock select.
	^ editor
]

{ #category : #'as yet unclassified' }
SBTest class >> mouseEventAt: aPoint [

	^ MouseEvent new
		setType: #mouseDown
		position: aPoint
		buttons: MouseEvent blueButton
		hand: ActiveHand
]

{ #category : #'as yet unclassified' }
SBTest class >> mouseEventAt: aPoint pressed: aPressedBoolean shift: aBoolean command: anotherBoolean control: aThirdBoolean [

	^ MouseButtonEvent new
		setType: (aPressedBoolean ifTrue: [#mouseDown] ifFalse: [#mouseUp])
		position: aPoint
		which: MouseEvent redButton
		buttons: (MouseEvent redButton bitOr: (((aBoolean ifTrue: [8] ifFalse: [0]) bitOr: (anotherBoolean ifTrue: [64] ifFalse: [0])) bitOr: (anotherBoolean ifTrue: [16] ifFalse: [0])))
		hand: ActiveHand
		stamp: nil
]

{ #category : #'as yet unclassified' }
SBTest class >> mouseEventAt: aPoint shift: aBoolean command: anotherBoolean control: aThirdBoolean [

	^ MouseButtonEvent new
		setType: #mouseDown
		position: aPoint
		which: MouseEvent redButton
		buttons: (MouseEvent redButton bitOr: (((aBoolean ifTrue: [8] ifFalse: [0]) bitOr: (anotherBoolean ifTrue: [64] ifFalse: [0])) bitOr: (anotherBoolean ifTrue: [16] ifFalse: [0])))
		hand: ActiveHand
		stamp: nil
]

{ #category : #'as yet unclassified' }
SBTest class >> mouseMoveEventAt: aPoint [

	^ MouseMoveEvent new
		setType: #mouseMove
		startPoint: aPoint
		endPoint: aPoint
		trail: nil
		buttons: 0
		hand: ActiveHand
		stamp: nil
]

{ #category : #'as yet unclassified' }
SBTest class >> mouseMoveEventAt: aPoint from: anotherPoint [

	^ MouseMoveEvent new
		setType: #mouseMove
		startPoint: anotherPoint
		endPoint: aPoint
		trail: {anotherPoint. aPoint}
		buttons: 0
		hand: ActiveHand
		stamp: nil
]

{ #category : #asserting }
SBTest >> assert: anObject structure: aCollection [

	aCollection do: [:assoc | self assert: assoc value equals: (anObject perform: assoc key)]
]

{ #category : #support }
SBTest >> editorAndWorldFor: aBlock [

	| editor |
	world := self offscreenWorld: 300 @ 200.
	editor := self editorFor: aBlock.
	editor openInWorld: world.
	self tick.
	^ editor
]

{ #category : #utilities }
SBTest >> editorDebug: anEditor [

	anEditor openInWindow.
	self halt
]

{ #category : #support }
SBTest >> editorFor: aBlock [

	^ self class editorFor: aBlock
]

{ #category : #'support - events' }
SBTest >> keyboardEvent: aCharacter [

	^ self class keyboardEvent: aCharacter
]

{ #category : #'support - events' }
SBTest >> keyboardEvent: aCharacter shift: aBoolean command: anotherBoolean [

	^ self class keyboardEvent: aCharacter shift: aBoolean command: anotherBoolean
]

{ #category : #'support - events' }
SBTest >> keyboardEvent: aCharacter shift: aBoolean command: anotherBoolean control: aThirdBoolean [

	^ self class keyboardEvent: aCharacter shift: aBoolean command: anotherBoolean control: aThirdBoolean
]

{ #category : #support }
SBTest >> methodFor: aBlock [

	^ self class methodFor: aBlock
]

{ #category : #support }
SBTest >> offscreenWorld: aPoint [

	| worldSize hand |
	worldSize := aPoint.
	world := (PasteUpMorph newWorldForProject: nil)
		extent: worldSize;
		viewBox: (0 @ 0 extent: worldSize);
		yourself.
	(world instVarNamed: #worldState)
		instVarNamed: #canvas
		put: (Form extent: worldSize depth: 32) getCanvas.
	hand := SBHandMorph new.
	world
		removeHand: world firstHand;
		addHand: hand.
	^ world
]

{ #category : #support }
SBTest >> parse: aString [

	^ aString parseAsSandblock
]

{ #category : #'support - events' }
SBTest >> send: anEvent to: anEditor [

	anEvent becomeActiveDuring: [anEditor filterEvent: anEvent for: nil]
]

{ #category : #'support - events' }
SBTest >> tick [

	(world ifNil: [World]) doOneCycleNow
]

{ #category : #'support - events' }
SBTest >> type: aStringOrEvent in: anEditor [

	aStringOrEvent isString ifFalse: [^ aStringOrEvent becomeActiveDuring: [anEditor handle: aStringOrEvent]].
	
	aStringOrEvent do: [:char | | event |
		event := self keyboardEvent: char.
		event becomeActiveDuring: [anEditor handle: event]]
]
