Class {
	#name : #SBStNumber,
	#superclass : #SBStLiteral,
	#instVars : [
		'isDown',
		'lastMousePosition',
		'oldCursor',
		'scrubbingCommand'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStNumber >> acceptInputEvent: anEvent [

	| char |
	char := anEvent keyCharacter.
	(char isAlphaNumeric or: [(char = $- and: [text isCursorAtStart]) or: [char = $.]])
		ifTrue: [super acceptInputEvent: anEvent]
		ifFalse: [SBStGrammarHandler new perform: char for: self empty: false]
]

{ #category : #'as yet unclassified' }
SBStNumber >> castToUnknownWhenEmpty [

	^ true
]

{ #category : #'as yet unclassified' }
SBStNumber >> guessedClass [

	^ [self parsedContents class] on: NumberParserError do: [Number]
]

{ #category : #'as yet unclassified' }
SBStNumber >> initialize [

	super initialize.
	
	isDown := false
]

{ #category : #'as yet unclassified' }
SBStNumber >> isNumberBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBStNumber >> keyStroke: anEvent [

	(anEvent keyCharacter = $- and: [text isCursorAtStart]) ifTrue: [^ self acceptInputEvent: anEvent].
	
	super keyStroke: anEvent.
	
	self contents: (self contents select: [:char | char isAlphaNumeric or: [char = $- or: [char = $.]]])
]

{ #category : #'as yet unclassified' }
SBStNumber >> mouseCursorAt: anEvent [

	^ Cursor resizeLeft
]

{ #category : #'as yet unclassified' }
SBStNumber >> mouseDown: anEvent [

	(self valid not or: [anEvent redButtonPressed not or: [anEvent anyModifierKeyPressed]]) ifTrue: [^ super mouseDown: anEvent].
	
	self click: anEvent.
	
	anEvent hand newMouseFocus: self.
	isDown := true.
	lastMousePosition := anEvent position.
	scrubbingCommand := SBMutatePropertyCommand new
		oldValue: self contents;
		selector: #contents;
		target: self.
	
	oldCursor := Cursor currentCursor.
	Cursor resizeLeft show
]

{ #category : #'as yet unclassified' }
SBStNumber >> mouseMove: anEvent [

	| delta |
	isDown ifTrue: [
		delta := anEvent position - lastMousePosition.
		self flag: #todo.
		"preserve formatting like base"
		self contents: (self parsedContents + delta x) asString.
		lastMousePosition := anEvent position.
		self batchedChangeStep]
]

{ #category : #'as yet unclassified' }
SBStNumber >> mouseUp: anEvent [

	super mouseUp: anEvent.
	isDown := false.
	oldCursor ifNotNil: #show.
	
	(scrubbingCommand notNil and: [scrubbingCommand oldValue ~= self contents]) ifTrue: [
		self sandblockEditor do: (scrubbingCommand value: self contents)].
	scrubbingCommand := nil
]

{ #category : #'as yet unclassified' }
SBStNumber >> parsedContents [

	^ self contents ifEmpty: [0] ifNotEmpty: [:num | num asNumber]
]

{ #category : #'as yet unclassified' }
SBStNumber >> printOn: aStream [

	aStream nextPutAll: 'number '.
	aStream nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBStNumber >> startDrag: anEvent [
	" block the pick-up handler "

	isDown ifFalse: [super startDrag: anEvent]
]

{ #category : #'as yet unclassified' }
SBStNumber >> symbols [

	^ self colorPolicy symbolsForNumber: self
]

{ #category : #'as yet unclassified' }
SBStNumber >> valid [

	| stream |
	SBExample self: [SBStNumber new contents: '43a'] args: [{}] label: 'invalid'.
	SBExample self: [SBStNumber new contents: '43'] args: [{}] label: 'valid'.
	stream := self contents readStream.
	[
		(ExtendedNumberParser on: stream) nextNumber.
		stream position = self contents size ifFalse: [^ false]] on: NumberParserError do: [^ false].
	^ true
]

{ #category : #'as yet unclassified' }
SBStNumber >> validContents [

	^ self valid
]

{ #category : #'as yet unclassified' }
SBStNumber >> value [

	^ self parsedContents
]

{ #category : #'as yet unclassified' }
SBStNumber >> value: aNumber [

	self contents: aNumber asString
]

{ #category : #'as yet unclassified' }
SBStNumber >> writeSourceOn: aStream [

	aStream nextPutAll: self contents
]
