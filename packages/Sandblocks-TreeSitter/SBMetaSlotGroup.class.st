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

	self elements do: [:element | element buildRepeatedFor: aMorph]
]

{ #category : #'as yet unclassified' }
SBMetaSlotGroup >> buildPartialFor: aMorph option: anOption with: aString [

	self elements first buildPartialFor: aMorph option: anOption with: aString.
	self elements allButFirstDo: [:element | element buildRepeatedFor: aMorph]
]

{ #category : #'as yet unclassified' }
SBMetaSlotGroup >> elements [

	^ elements
]

{ #category : #'as yet unclassified' }
SBMetaSlotGroup >> elements: aCollection [

	elements := aCollection
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

	| stream morph restore |
	morph := aStream peek.
	stream := self hasOwnBlock ifTrue: [morph submorphs readStream] ifFalse: [aStream].
	restore := stream position.
	self elements withIndexDo: [:element :index | | count |
		stream atEnd ifTrue: [
			stream position: restore.
			^ false].
		count := 0.
		(element morphsIn: stream do: [:slot :morphs |
			count := morphs size.
			aBlock value: slot value: morphs])
			ifTrue: [count > 0 ifTrue: [stream next]]
			ifFalse: [
				stream position: restore.
				^ false]].
	
	self hasOwnBlock ifTrue: [aBlock value: self value: {morph}].
	
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
