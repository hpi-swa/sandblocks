Class {
	#name : #SBSelectionDecorator,
	#superclass : #SBBlockDecorator,
	#instVars : [
		'cursorShown',
		'blinkCount'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBSelectionDecorator >> attached: aMorph [

	super attached: aMorph.
	aMorph sandblockEditor when: #keyboardFocusChanged send: #focusChanged: to: self
]

{ #category : #'as yet unclassified' }
SBSelectionDecorator >> color [

	^ self morph colorPolicy selectionColorForBlock: (self morph parentSandblock ifNil: [self morph])
]

{ #category : #'as yet unclassified' }
SBSelectionDecorator >> cursorAlwaysVisible [

	^ self morph sandblockEditor hasKeyboardFocus not or: [blinkCount >= self maxBlickCount]
]

{ #category : #'as yet unclassified' }
SBSelectionDecorator >> cursorVisible [

	^ cursorShown or: [self cursorAlwaysVisible]
]

{ #category : #'as yet unclassified' }
SBSelectionDecorator >> detached: aMorph [

	super detached: aMorph.
	aMorph sandblockEditor removeActionsWithReceiver: self
]

{ #category : #'as yet unclassified' }
SBSelectionDecorator >> focusChanged: aBoolean [

	blinkCount := aBoolean ifTrue: [0] ifFalse: [self maxBlickCount].
	self morph ifNotNil: #updateSteppingDecorators.
	self changed
]

{ #category : #'as yet unclassified' }
SBSelectionDecorator >> initialize [

	super initialize.
	cursorShown := false.
	blinkCount := 0
]

{ #category : #'as yet unclassified' }
SBSelectionDecorator >> maxBlickCount [

	^ 20
]

{ #category : #'as yet unclassified' }
SBSelectionDecorator >> resetBlink [

	
	blinkCount := 0.
	cursorShown := false.
	
	self morph world ifNotNil: [:w |
		w stopStepping: self.
		w startStepping: self at: Time millisecondClockValue selector: #step arguments: {} stepTime: self stepTime]
]

{ #category : #'as yet unclassified' }
SBSelectionDecorator >> step [

	cursorShown := cursorShown not.
	self cursorAlwaysVisible ifFalse: [self morph invalidRect: (self morph outerBounds expandBy: 4)].
	blinkCount := blinkCount + 1.
	blinkCount > self maxBlickCount ifTrue: [self morph updateSteppingDecorators]
]

{ #category : #'as yet unclassified' }
SBSelectionDecorator >> stepTime [

	^ blinkCount < self maxBlickCount ifTrue: [500] ifFalse: [-1]
]
