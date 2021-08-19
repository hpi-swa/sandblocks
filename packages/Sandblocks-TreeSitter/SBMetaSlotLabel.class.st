Class {
	#name : #SBMetaSlotLabel,
	#superclass : #SBMetaSlot,
	#instVars : [
		'label'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBMetaSlotLabel >> = aSlot [

	^ super = aSlot and: [aSlot label = self label]
]

{ #category : #'as yet unclassified' }
SBMetaSlotLabel >> buildFor: aMorph [

	^ aMorph addMorphBack: (SBStringMorph new contents: self label)
]

{ #category : #'as yet unclassified' }
SBMetaSlotLabel >> buildPartialFor: aMorph option: anOption with: aString [

	^ aMorph addMorphBack: (SBStringMorph new contents: self label)
]

{ #category : #'as yet unclassified' }
SBMetaSlotLabel >> cursorPositionsIn: aStream factory: aFactory do: aBlock [

	^ (self checkValidIn: aStream)
		ifTrue: [
			aStream next.
			true]
		ifFalse: [false]
]

{ #category : #'as yet unclassified' }
SBMetaSlotLabel >> hash [

	^ label hash
]

{ #category : #'as yet unclassified' }
SBMetaSlotLabel >> label [

	^ label
]

{ #category : #'as yet unclassified' }
SBMetaSlotLabel >> label: anObject [

	label := anObject
]

{ #category : #'as yet unclassified' }
SBMetaSlotLabel >> morphsIn: aStream do: aBlock [

	^ (self checkValidIn: aStream)
		ifTrue: [
			aBlock value: self value: {aStream next}.
			true]
		ifFalse: [false]
]

{ #category : #'as yet unclassified' }
SBMetaSlotLabel >> printTitleOn: aStream [

	aStream nextPut: $".
	aStream nextPutAll: label.
	aStream nextPut: $"
]

{ #category : #'as yet unclassified' }
SBMetaSlotLabel >> takeFrom: aCursor for: aMorph [

	^ aCursor text withBlanksTrimmed = self label
		ifTrue: [
			aMorph addMorphBack: (SBStringMorph new contents: self label).
			aCursor gotoNextSibling.
			true]
		ifFalse: [false]
]

{ #category : #'as yet unclassified' }
SBMetaSlotLabel >> triggersFor: aString matchFullToken: aBoolean do: aBlock [

	^ aBlock
		addLeaf: self
		if: [:option | aBoolean ifTrue: [self label = aString] ifFalse: [self label beginsWith: aString]]
]

{ #category : #'as yet unclassified' }
SBMetaSlotLabel >> validIn: aStream [

	^ aStream peek contents = self label
		ifTrue: [
			aStream next.
			true]
		ifFalse: [false]
]
