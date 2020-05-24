Class {
	#name : #SBMessagePart,
	#superclass : #SBASTNode,
	#instVars : [
		'text'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBMessagePart >> childSandblocksDo: aBlock [
]

{ #category : #'as yet unclassified' }
SBMessagePart >> contents [

	^ text contents
]

{ #category : #'as yet unclassified' }
SBMessagePart >> contents: aString [

	text contents: aString
]

{ #category : #'as yet unclassified' }
SBMessagePart >> currentTextMorph [

	^ text
]

{ #category : #'as yet unclassified' }
SBMessagePart >> drawnColor [

	^ super drawnColor alpha: 0
]

{ #category : #'as yet unclassified' }
SBMessagePart >> initialize [

	super initialize.
	
	self
		addMorphBack: (text := SBOwnTextMorph new emphasis: TextEmphasis bold);
		layoutPolicy: SBVerticalLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBMessagePart >> insertUnknownAfterAndInput: aBoolean [

	| new |
	new := SBUnknown new.
	self sandblockEditor currentInputCommand shouldMergeWithNext: true.
	self sandblockEditor
		endInput;
		do: ((SBInsertCommand newFor: self containingArtefact)
			morph: new;
			container: self owner;
			shouldMergeWithNext: true;
			index: self childIndex + 1);
		startInput: new at: 1 replacingContents: false
]

{ #category : #'as yet unclassified' }
SBMessagePart >> isBinary [

	^ self contents notEmpty and: [self contents first isSpecial]
]

{ #category : #'as yet unclassified' }
SBMessagePart >> isFirstPart [

	^ self owner firstSubmorph = self
]

{ #category : #'as yet unclassified' }
SBMessagePart >> keyStroke: anEvent [

	(anEvent keyCharacter = Character backspace and: [self contents isEmpty and: [self isFirstPart]]) ifTrue: [ 
		^ self messageSend tryDelete].
	
	(self isBinary and: [anEvent keyCharacter isSpecial not]) ifTrue: [
		self sandblockEditor startInput: (self adjacentBlock: 1) at: 0 replacingContents: false.
		^ self sandblockEditor selection keyStroke: anEvent].
	
	text keyStroke: anEvent.
	
	(anEvent keyCharacter isSpecial and: [self contents size = 1 and: [self isFirstPart]]) ifTrue: [^ self insertUnknownAfterAndInput: false].
	anEvent keyCharacter = $: ifTrue: [self insertUnknownAfterAndInput: true]
]

{ #category : #'as yet unclassified' }
SBMessagePart >> messageSend [

	^ self parentSandblock
]

{ #category : #'as yet unclassified' }
SBMessagePart >> printOn: aStream [

	aStream
		nextPutAll: 'message part ';
		nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBMessagePart >> startInputAt: aNumber replacingContents: aBoolean [

	| cmd |
	cmd := (SBInputCommand newFor: self containingArtefact)
		oldMorph: self;
		previousText: self contents;
		yourself.
	
	aBoolean ifTrue: [text contents: ''].
	text moveCursorTo: aNumber.
	
	^ cmd
]

{ #category : #'as yet unclassified' }
SBMessagePart >> stopEditing: aCommand [

	aCommand
		newText: self contents;
		newMorph: self.
	
	text stopEditing
]

{ #category : #'as yet unclassified' }
SBMessagePart >> textContents [

	^ self contents
]
