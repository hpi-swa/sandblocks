Class {
	#name : #SBPoint,
	#superclass : #SBSubstitution,
	#instVars : [
		'isDown',
		'lastMousePosition',
		'scrubbingCommand',
		'oldCursor',
		'type'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBPoint class >> matches: aBlock [

	(super matches: aBlock) ifFalse: [^ false].

	^ (aBlock selector = '@' or: [aBlock selector = ',']) and: [aBlock receiver isNumberBlock] and: [aBlock arguments first isNumberBlock]
]

{ #category : #'as yet unclassified' }
SBPoint class >> newFor: aBlock [

	^ self new
		x: aBlock receiver y: aBlock arguments first;
		type: Point
]

{ #category : #'as yet unclassified' }
SBPoint >> childSandblocksDo: aBlock [

	aBlock value: self firstSubmorph.
	aBlock value: self lastSubmorph
]

{ #category : #'as yet unclassified' }
SBPoint >> contents [

	^ self firstSubmorph parsedContents @ self lastSubmorph parsedContents
]

{ #category : #'as yet unclassified' }
SBPoint >> contents: aPoint [

	self firstSubmorph contents: aPoint x asString.
	self lastSubmorph contents: aPoint y asString
]

{ #category : #'as yet unclassified' }
SBPoint >> guessedClass [

	^ Point
]

{ #category : #'as yet unclassified' }
SBPoint >> initialize [

	super initialize.
	
	isDown := false.
	
	self
		layoutPolicy: SBHorizontalLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBPoint >> messageSelector [

	^ type = ECSVector2 ifTrue: [#,] ifFalse: [#@]
]

{ #category : #'as yet unclassified' }
SBPoint >> mouseDown: anEvent [

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
SBPoint >> mouseMove: anEvent [

	| delta |
	isDown ifTrue: [
		delta := anEvent position - lastMousePosition.
		self flag: #todo. "preserve formatting like base"
		self contents: self parsedContents + delta.
		lastMousePosition := anEvent position.
		self sandblockEditor batchedChangeStep: self]
]

{ #category : #'as yet unclassified' }
SBPoint >> mouseUp: anEvent [

	super mouseUp: anEvent.
	isDown := false.
	oldCursor ifNotNil: #show.
	
	scrubbingCommand oldValue ~= self contents ifTrue: [
		self sandblockEditor do: (scrubbingCommand value: self contents)].
	scrubbingCommand := nil
]

{ #category : #'as yet unclassified' }
SBPoint >> parsedContents [

	^ self firstSubmorph parsedContents @ self lastSubmorph parsedContents
]

{ #category : #'as yet unclassified' }
SBPoint >> printOn: aStream [

	aStream nextPutAll: 'point '.
	self writeSourceOn: aStream
]

{ #category : #'as yet unclassified' }
SBPoint >> startDrag: anEvent [

	" block the pick-up handler "
]

{ #category : #'as yet unclassified' }
SBPoint >> type: aClass [

	type := aClass.
	self hasSubmorphs ifTrue: [self submorphs second contents: self messageSelector asString]
]

{ #category : #'as yet unclassified' }
SBPoint >> writeSourceOn: aStream [

	aStream nextPut: $(.
	self firstSubmorph writeSourceOn: aStream.
	aStream space; nextPutAll: self messageSelector asString; space.
	self lastSubmorph writeSourceOn: aStream.
	aStream nextPut: $)
]

{ #category : #'as yet unclassified' }
SBPoint >> x: aXBlock y: aYBlock [

	self
		addMorphBack: aXBlock;
		addMorphBack: (SBStringMorph new contents: '@');
		addMorphBack: aYBlock
]
