Class {
	#name : #SBPoint,
	#superclass : #SBStSubstitution,
	#instVars : [
		'isDown',
		'lastMousePosition',
		'scrubbingCommand',
		'oldCursor',
		'type'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #suggestions }
SBPoint class >> instanceSuggestion [

	^ [self new]
]

{ #category : #testing }
SBPoint class >> matches: aBlock [

	(aBlock isKindOf: SBPoint) ifTrue: [^ true].
	
	(super matches: aBlock) ifFalse: [^ false].
	
	^ (aBlock selector = '@' or: [aBlock selector = ',']) and: [aBlock receiver isNumberBlock] and: [aBlock arguments first isNumberBlock]
]

{ #category : #'instance creation' }
SBPoint class >> newFor: aBlock [

	(aBlock isKindOf: SBPoint) ifTrue: [^ aBlock veryDeepCopy].

	^ self new
		x: aBlock receiver veryDeepCopy y: aBlock arguments first veryDeepCopy;
		type: Point
]

{ #category : #'instance creation' }
SBPoint class >> newForPoint: aPoint [

	^ self new
		x: (SBStNumber new contents: aPoint x asString) y: (SBStNumber new contents: aPoint y asString);
		type: Point
]

{ #category : #accessing }
SBPoint class >> priority [

	^ 21000
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
		hResizing: #shrinkWrap;
		x: (SBStNumber new contents: '0') y: (SBStNumber new contents: '0')
]

{ #category : #'as yet unclassified' }
SBPoint >> messageSelector [

	^ #@
]

{ #category : #'as yet unclassified' }
SBPoint >> mouseDown: anEvent [

	super mouseDown: anEvent.
	
	self valid ifFalse: [^ self].
	
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
SBPoint >> mouseMove: anEvent [

	| delta |
	isDown ifTrue: [
		delta := anEvent position - lastMousePosition.
		self flag: #todo.
		"preserve formatting like base"
		self contents: self parsedContents + delta.
		lastMousePosition := anEvent position.
		self batchedChangeStep]
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
SBPoint >> pickCoordinate [
	<action>

	| p |
	p := Cursor crossHair showWhile: [Sensor waitButton].
	self sandblockEditor do: (SBMutatePropertyCommand new
		oldValue: self contents;
		selector: #contents;
		value: p;
		target: self)
]

{ #category : #'as yet unclassified' }
SBPoint >> pickExtent [
	<action>

	| corner origin |
	Cursor crossHair showWhile: [
		origin := Sensor waitButton.
		corner := Sensor waitNoButton].
	self sandblockEditor do: (SBMutatePropertyCommand new
		oldValue: self contents;
		selector: #contents;
		value: (Rectangle encompassing: {origin. corner}) extent;
		target: self)
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
		removeAllMorphs;
		addMorphBack: aXBlock;
		addMorphBack: (SBStringMorph new contents: '@');
		addMorphBack: aYBlock
]
