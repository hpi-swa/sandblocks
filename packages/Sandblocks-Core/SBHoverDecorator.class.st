Class {
	#name : #SBHoverDecorator,
	#superclass : #SBBlockDecorator,
	#instVars : [
		'shown',
		'position',
		'cursor'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBHoverDecorator >> attached: aMorph [

	super attached: aMorph.
	
	shown := true.
	SBToggledCode comment: '' active: 0 do: {
		[
			aMorph world
				addAlarm: #startShowing
				withArguments: #()
				for: self
				at: Time millisecondClockValue + 10]}
]

{ #category : #'as yet unclassified' }
SBHoverDecorator >> color [

	^ self morph colorPolicy selectionColorForBlock: (self morph parentSandblock ifNil: [self morph])
]

{ #category : #'as yet unclassified' }
SBHoverDecorator >> detached: aMorph [

	self position: nil.
	super detached: aMorph.
	
	shown ifFalse: [aMorph world ifNotNil: [:w | w removeAlarm: #startShowing for: self]]
]

{ #category : #'as yet unclassified' }
SBHoverDecorator >> position: aPoint [

	| newCursor |
	position := aPoint.
	
	newCursor := (self morph notNil and: [self morph sandblockEditor notNil])
		ifTrue: [ | c |
			c := self morph sandblockEditor cursor
				cursorForBlock: self morph
				at: position.
			(c isKindOf: SBCursorText)
				ifTrue: [SBCursorSelect new block: c block]
				ifFalse: [c]]
		ifFalse: [nil].
	newCursor ~= cursor ifTrue: [
		cursor ifNotNil: [self morph invalidRect: cursor bounds].
		cursor := newCursor.
		cursor ifNotNil: [self morph invalidRect: cursor bounds]]
]

{ #category : #'as yet unclassified' }
SBHoverDecorator >> postDrawOn: aCanvas [

	(self shown and: [SBPreferences showHoverDecorator and: [cursor notNil and: [ActiveHand hasSubmorphs not]]]) ifTrue: [ | c |
		c := (cursor isKindOf: SBCursorText)
			ifTrue: [SBCursorSelect new block: cursor block]
			ifFalse: [cursor].
		c drawOn: aCanvas in: c bounds color: (self color alpha: 0.15)]
]

{ #category : #'as yet unclassified' }
SBHoverDecorator >> shown [

	^ shown ifNil: [false]
]

{ #category : #'as yet unclassified' }
SBHoverDecorator >> startShowing [

	shown := true.
	self morph changed
]
