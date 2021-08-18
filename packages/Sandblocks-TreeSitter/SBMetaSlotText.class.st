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
SBMetaSlotText >> cursorPositionsIn: aStream factory: aFactory do: aBlock [

	aStream peek containingSandblock startInputCommand ifNotNil: [:command |
		aBlock value: (SBCursorText new
			block: aStream next containingSandblock;
			currentCommand: command)].
	^ true
]

{ #category : #'as yet unclassified' }
SBMetaSlotText >> hash [

	^ regexString hash
]

{ #category : #'as yet unclassified' }
SBMetaSlotText >> morphsIn: aStream do: aBlock [

	^ aStream peek isTextMorph
		ifNotNil: [
			aBlock value: self value: {aStream next}.
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

{ #category : #'as yet unclassified' }
SBMetaSlotText >> validIn: aStream [

	^ aStream peek isTextMorph
		ifTrue: [
			aStream next.
			true]
		ifFalse: [false]
]
