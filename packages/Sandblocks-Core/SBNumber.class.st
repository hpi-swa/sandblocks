Class {
	#name : #SBNumber,
	#superclass : #SBStLiteral,
	#instVars : [
		'isDown',
		'lastMousePosition',
		'oldCursor',
		'scrubbingCommand'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBNumber >> acceptInputEvent: anEvent [

	| char |
	char := anEvent keyCharacter.
	(char isAlphaNumeric or: [char = $- or: [char = $.]])
		ifTrue: [super acceptInputEvent: anEvent]
		ifFalse: [SBSmalltalkGrammarHandler new perform: char for: self empty: false]
]

{ #category : #'as yet unclassified' }
SBNumber >> castToUnknownWhenEmpty [

	^ true
]

{ #category : #'as yet unclassified' }
SBNumber >> guessedClass [

	^ [self parsedContents class] on: NumberParserError do: [Number]
]

{ #category : #'as yet unclassified' }
SBNumber >> initialize [

	super initialize.
	
	isDown := false
]

{ #category : #'as yet unclassified' }
SBNumber >> isNumberBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBNumber >> keyStroke: anEvent [

	(anEvent keyCharacter = $- and: [text isCursorAtStart]) ifTrue: [^ self acceptInputEvent: anEvent].
	
	super keyStroke: anEvent.
	
	self contents: (self contents select: [:char | char isAlphaNumeric or: [char = $- or: [char = $.]]])
]

{ #category : #'as yet unclassified' }
SBNumber >> mouseDown: anEvent [

	super mouseDown: anEvent.
	
	self valid ifFalse: [^ self].
	anEvent redButtonPressed ifFalse: [^ self].
	
	anEvent hand newMouseFocus: self.
	isDown := true.
	lastMousePosition := anEvent position.
	scrubbingCommand := (SBMutatePropertyCommand newOrEditFor: self containingArtefact)
		oldValue: self contents;
		selector: #contents;
		target: self.
	
	oldCursor := Cursor currentCursor.
	Cursor resizeLeft show
]

{ #category : #'as yet unclassified' }
SBNumber >> mouseMove: anEvent [

	| delta |
	isDown ifTrue: [
		delta := anEvent position - lastMousePosition.
		self flag: #todo. "preserve formatting like base"
		self contents: (self parsedContents + delta x) asString.
		lastMousePosition := anEvent position.
		self sandblockEditor batchedChangeStep: self]
]

{ #category : #'as yet unclassified' }
SBNumber >> mouseUp: anEvent [

	super mouseUp: anEvent.
	isDown := false.
	oldCursor ifNotNil: #show.
	
	(scrubbingCommand notNil and: [scrubbingCommand oldValue ~= self contents]) ifTrue: [
		self sandblockEditor do: (scrubbingCommand value: self contents)].
	scrubbingCommand := nil
]

{ #category : #'as yet unclassified' }
SBNumber >> parsedContents [

	^ self contents ifEmpty: [0] ifNotEmpty: [:num | num asNumber]
]

{ #category : #'as yet unclassified' }
SBNumber >> printOn: aStream [

	aStream nextPutAll: 'number '.
	aStream nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBNumber >> startDrag: anEvent [

	" block the pick-up handler "
]

{ #category : #'as yet unclassified' }
SBNumber >> symbols [

	^ self colorPolicy symbolsForNumber: self
]

{ #category : #'as yet unclassified' }
SBNumber >> valid [

	| stream |
	SBExample self: [SBNumber new contents: '43a'] args: [{}] label: 'invalid'.
	SBExample self: [SBNumber new contents: '43'] args: [{}] label: 'valid'.
	stream := self contents readStream.
	[
		(ExtendedNumberParser on: stream) nextNumber.
		stream position = self contents size ifFalse: [^ false]] on: NumberParserError do: [^ false].
	^ true
]

{ #category : #'as yet unclassified' }
SBNumber >> value [

	^ self parsedContents
]

{ #category : #'as yet unclassified' }
SBNumber >> value: aNumber [

	self contents: aNumber asString
]

{ #category : #'as yet unclassified' }
SBNumber >> writeSourceOn: aStream [

	aStream nextPutAll: self contents
]
