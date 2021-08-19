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
SBMetaSlotText >> = aSlot [

	^ super = aSlot and: [aSlot regexString = self regexString]
]

{ #category : #'as yet unclassified' }
SBMetaSlotText >> buildFor: aMorph [

	aMorph textFieldPattern: self regex
]

{ #category : #'as yet unclassified' }
SBMetaSlotText >> buildPartialFor: aMorph option: anOption with: aString [

	aMorph
		textFieldPattern: self regex;
		contents: aString
]

{ #category : #'as yet unclassified' }
SBMetaSlotText >> cursorPositionsDo: aBlock in: aStream [

	aStream peek containingSandblock startInputCommand ifNotNil: [:command |
		aBlock value: (SBCursorText new
			block: aStream peek containingSandblock;
			currentCommand: command)]
]

{ #category : #'as yet unclassified' }
SBMetaSlotText >> hash [

	^ regexString hash
]

{ #category : #'as yet unclassified' }
SBMetaSlotText >> morphsIn: aStream do: aBlock [

	^ aStream peek isTextMorph
		ifNotNil: [
			aBlock value: self value: {aStream peek}.
			true]
		ifNil: [false]
]

{ #category : #'as yet unclassified' }
SBMetaSlotText >> printTitleOn: aStream [

	aStream nextPutAll: 'r"'.
	aStream nextPutAll: regexString.
	aStream nextPutAll: '"'
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
			aCursor gotoNextSibling.
			true]
		ifFalse: [false]
]

{ #category : #'as yet unclassified' }
SBMetaSlotText >> triggersFor: aString matchFullToken: aBoolean do: aBlock [

	^ aBlock addLeafIf: [:option | aBoolean ifTrue: [self regex matches: aString] ifFalse: [self regex matchesPrefix: aString]]
]
