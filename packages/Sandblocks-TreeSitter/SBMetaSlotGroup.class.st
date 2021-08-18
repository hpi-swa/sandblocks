Class {
	#name : #SBMetaSlotGroup,
	#superclass : #SBMetaSlot,
	#instVars : [
		'elements',
		'hasOwnBlock'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBMetaSlotGroup >> = aSlot [

	^ super = aSlot and: [self elements hasEqualElements: aSlot elements]
]

{ #category : #'as yet unclassified' }
SBMetaSlotGroup >> buildFor: aMorph [

	self elements do: [:element | element buildFor: aMorph]
]

{ #category : #'as yet unclassified' }
SBMetaSlotGroup >> buildPartialFor: aMorph option: anOption with: aString [

	self elements first buildPartialFor: aMorph option: anOption with: aString.
	self elements allButFirstDo: [:element | element buildFor: aMorph]
]

{ #category : #'as yet unclassified' }
SBMetaSlotGroup >> cursorPositionsIn: aStream factory: aFactory do: aBlock [

	| stream morph |
	(self checkValidIn: aStream) ifFalse: [^ false].
	
	morph := aStream peek.
	stream := self hasOwnBlock ifTrue: [morph submorphs readStream] ifFalse: [aStream].
	
	self hasOwnBlock ifTrue: [ | block |
		block := aStream last.
		aBlock value: (SBCursorSelect new block: block).
		^ block cursorPositionsDo: aBlock].
	
	self elements withIndexDo: [:element :index | (element cursorPositionsIn: stream factory: aFactory do: aBlock) ifFalse: [^ false]].
	
	^ true
]

{ #category : #'as yet unclassified' }
SBMetaSlotGroup >> elements [

	^ elements
]

{ #category : #'as yet unclassified' }
SBMetaSlotGroup >> elements: aCollection [

	elements := aCollection.
	elements do: [:element | element parent: self]
]

{ #category : #'as yet unclassified' }
SBMetaSlotGroup >> hasOwnBlock [

	^ hasOwnBlock
]

{ #category : #'as yet unclassified' }
SBMetaSlotGroup >> hash [

	^ elements hash
]

{ #category : #'as yet unclassified' }
SBMetaSlotGroup >> initialize [

	super initialize.
	
	hasOwnBlock := true
]

{ #category : #'as yet unclassified' }
SBMetaSlotGroup >> isRoot: aBoolean [

	hasOwnBlock := aBoolean not
]

{ #category : #'as yet unclassified' }
SBMetaSlotGroup >> morphsIn: aStream do: aBlock [

	| stream morph |
	(self checkValidIn: aStream) ifFalse: [^ false].
	
	morph := aStream peek.
	stream := self hasOwnBlock ifTrue: [morph submorphs readStream] ifFalse: [aStream].
	self elements withIndexDo: [:element :index | element morphsIn: stream do: aBlock].
	
	self hasOwnBlock ifTrue: [
		aBlock value: self value: {morph}.
		aStream next].
	
	^ true
]

{ #category : #'as yet unclassified' }
SBMetaSlotGroup >> printTitleOn: aStream [

	elements do: [:alt | aStream print: alt] separatedBy: [aStream nextPut: $,]
]

{ #category : #'as yet unclassified' }
SBMetaSlotGroup >> takeFrom: aCursor for: aMorph [

	self elements withIndexDo: [:element :index |
		(element takeFrom: aCursor for: aMorph)
			ifFalse: [^ false]].
	
	^ true
]

{ #category : #'as yet unclassified' }
SBMetaSlotGroup >> triggersFor: aString matchFullToken: aBoolean do: aBlock [

	^ self elements first triggersFor: aString matchFullToken: aBoolean do: aBlock
]

{ #category : #'as yet unclassified' }
SBMetaSlotGroup >> validIn: aStream [

	| restore stream |
	restore := aStream position.
	stream := self hasOwnBlock
		ifTrue: [aStream peek submorphs readStream]
		ifFalse: [aStream].
	self elements do: [:element |
		stream atEnd ifTrue: [^ false].
		(element validIn: stream) ifFalse: [
			stream position: restore.
			^ false]].
	self hasOwnBlock ifTrue: [aStream next].
	^ true
]
