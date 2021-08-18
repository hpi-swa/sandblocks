Class {
	#name : #SBMetaSlotBlock,
	#superclass : #SBMetaSlot,
	#instVars : [
		'type',
		'factory'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBMetaSlotBlock class >> topLevel: aTypeString factory: aFactory [

	^ self new type: aTypeString factory: aFactory
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> = aSlot [

	^ super = aSlot and: [aSlot type = self type]
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> buildFor: aMorph [

	aMorph addMorphBack: (aMorph factory unknownFor: self)
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> buildPartialFor: aMorph option: anOption with: aString [

	| morph |
	morph := SBMetaBlock new factory: factory parentSlot: self.
	(factory slotsFor: type) buildPartialFor: morph option: anOption with: aString.
	aMorph addMorphBack: morph
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> cursorPositionsIn: aStream factory: aFactory do: aBlock [

	^ (self checkValidIn: aStream)
		ifTrue: [ | block |
			block := aStream next.
			aBlock value: (SBCursorSelect new block: block).
			block cursorPositionsDo: aBlock.
			true]
		ifFalse: [false]
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> factory [

	^ factory
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> hash [

	^ type hash
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> isBlockSlot [

	^ true
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> morphsIn: aStream do: aBlock [

	^ (self checkValidIn: aStream)
		ifTrue: [
			aBlock value: self value: {aStream next}.
			true]
		ifFalse: [false]
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> printTitleOn: aStream [

	aStream nextPutAll: type
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> takeFrom: aCursor for: aMorph [

	^ (aCursor factory type: aCursor type compatibleWith: type)
		ifTrue: [
			aMorph addMorphBack: (aCursor buildMorphFor: (SBMetaSlotBlock new type: aCursor type factory: factory)).
			true]
		ifFalse: [false]
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> triggersFor: aString matchFullToken: aBoolean do: anOption [

	^ (anOption hasVisitedSymbol: self type) ifTrue: [false] ifFalse: [
		anOption addVisitedSymbol: self type.
		(factory slotsFor: self type)
			triggersFor: aString
			matchFullToken: aBoolean
			do: anOption]
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> type [

	^ type
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> type: aString factory: aFactory [

	type := aString.
	factory := aFactory
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> validIn: aStream [

	^ (aStream peek isMetaBlock and: [aStream peek parentSlot isBlockSlot and: [factory type: aStream peek parentSlot type compatibleWith: type]])
		ifTrue: [
			aStream next.
			true]
		ifFalse: [false]
]
