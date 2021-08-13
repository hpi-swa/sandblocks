Class {
	#name : #SBMetaSlotLabel,
	#superclass : #SBMetaSlot,
	#instVars : [
		'label'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBMetaSlotLabel >> applyToMorph: block getText: aTextBlock buildChild: aBlock [

	block addMorphBack: (SBStringMorph new contents: self label)
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
SBMetaSlotLabel >> matchesNode: aNode ts: aLibrary [

	^ (aLibrary textForNode: aNode) withBlanksTrimmed = self label
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
