Class {
	#name : #SBMetaSlotLabel,
	#superclass : #SBMetaSlot,
	#instVars : [
		'label'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBMetaSlotLabel >> buildFor: aMorph [

	^ aMorph addMorphBack: (SBStringMorph new contents: self label)
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
SBMetaSlotLabel >> matchesMorph: aMorph in: aFactory [

	^ aMorph contents = self label
]

{ #category : #'as yet unclassified' }
SBMetaSlotLabel >> printOn: aStream [

	aStream nextPutAll: self className.
	aStream nextPut: $(.
	aStream nextPut: $'.
	aStream nextPutAll: label.
	aStream nextPut: $'.
	self multiple ifTrue: [aStream nextPutAll: ',multiple'].
	self required ifTrue: [aStream nextPutAll: ',required'].
	aStream nextPut: $)
]

{ #category : #'as yet unclassified' }
SBMetaSlotLabel >> takeFrom: aCursor for: aMorph [

	^ aCursor text withBlanksTrimmed = self label
		ifTrue: [
			aMorph addMorphBack: (SBStringMorph new contents: self label).
			true]
		ifFalse: [false]
]
