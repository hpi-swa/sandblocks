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
SBMetaSlotText >> buildFor: aMorph [

	aMorph textFieldPattern: self regex
]

{ #category : #'as yet unclassified' }
SBMetaSlotText >> matchesMorph: aMorph in: aFactory [

	^ SBToggledCode comment: '' active: 1 do: {[true]. [self regex matches: aMorph contents]}
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

{ #category : #'as yet unclassified' }
SBMetaSlotText >> takeFrom: aCursor for: aMorph [

	^ true
		ifTrue: [
			aMorph textFieldPattern: self regex.
			aMorph contents: aCursor text.
			true]
		ifFalse: [false]
]
