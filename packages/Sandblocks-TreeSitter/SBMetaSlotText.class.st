Class {
	#name : #SBMetaSlotText,
	#superclass : #SBMetaSlot,
	#instVars : [
		'regex',
		'regexString'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBMetaSlotText >> applyToMorph: block getText: aTextBlock buildChild: aBlock [

	block textFieldPattern: self regex.
	aTextBlock ifNotNil: [block contents: (aTextBlock cull: self)]
]

{ #category : #'as yet unclassified' }
SBMetaSlotText >> matchesMorph: aMorph in: aFactory [

	^ SBToggledCode comment: '' active: 1 do: {[true]. [self regex matches: aMorph contents]}
]

{ #category : #'as yet unclassified' }
SBMetaSlotText >> matchesNode: aNode ts: aLibrary [

	^ self regex matches: (aLibrary textForNode: aNode)
]

{ #category : #'as yet unclassified' }
SBMetaSlotText >> printOn: aStream [

	aStream nextPutAll: self className.
	aStream nextPut: $(.
	aStream nextPut: $'.
	aStream nextPutAll: regexString.
	self multiple ifTrue: [aStream nextPutAll: ',multiple'].
	self required ifTrue: [aStream nextPutAll: ',required'].
	aStream nextPut: $'.
	aStream nextPut: $)
]

{ #category : #'as yet unclassified' }
SBMetaSlotText >> regex [

	^ regex
]

{ #category : #'as yet unclassified' }
SBMetaSlotText >> regex: anObject [

	regex := anObject
]

{ #category : #'as yet unclassified' }
SBMetaSlotText >> regexString [

	^ regexString
]

{ #category : #'as yet unclassified' }
SBMetaSlotText >> regexString: aString [

	self regex: aString asRegex.
	regexString := aString
]
