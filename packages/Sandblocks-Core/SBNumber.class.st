Class {
	#name : #SBNumber,
	#superclass : #SBLiteral,
	#instVars : [
		'isDown',
		'lastMousePosition',
		'oldCursor',
		'scrubbingCommand'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBNumber >> guessedClass [

	^ Number
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

	(anEvent keyCharacter = $- and: [text isCursorAtStart]) ifTrue: [
		^ self acceptInputEvent: anEvent].
	super keyStroke: anEvent
]

{ #category : #'as yet unclassified' }
SBNumber >> mouseDown: anEvent [

	super mouseDown: anEvent.
	
	self valid ifFalse: [^ self].
	
	anEvent hand newMouseFocus: self.
	isDown := true.
	lastMousePosition := anEvent position.
	scrubbingCommand := (SBMutatePropertyCommand newFor: self containingArtefact)
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
	
	scrubbingCommand oldValue ~= self contents ifTrue: [
		self sandblockEditor do: (scrubbingCommand value: self contents)].
	scrubbingCommand := nil
]

{ #category : #'as yet unclassified' }
SBNumber >> parsedContents [

	^ self contents asNumber
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
SBNumber >> valid [

	[self contents asNumber] on: NumberParserError do: [^ false].
	^ true
]

{ #category : #'as yet unclassified' }
SBNumber >> writeSourceOn: aStream [

	aStream nextPutAll: self contents
]
