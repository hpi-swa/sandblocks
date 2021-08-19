Class {
	#name : #SBMetaSlot,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBMetaSlot class >> any [

	^ self new
		multiple: true;
		required: false;
		yourself
]

{ #category : #'as yet unclassified' }
SBMetaSlot class >> atLeastOne [

	^ self new
		multiple: true;
		required: true;
		yourself
]

{ #category : #'as yet unclassified' }
SBMetaSlot class >> one [

	^ self new
		multiple: false;
		required: true;
		yourself
]

{ #category : #'as yet unclassified' }
SBMetaSlot class >> optional [

	^ self new
		multiple: false;
		required: false;
		yourself
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> = aSlot [

	^ self class = aSlot class
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> buildFor: aMorph [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> buildPartialFor: aMorph option: anOption with: aString [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> buildRepeatedFor: aMorph [

	self required ifTrue: [self buildFor: aMorph]
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> hash [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> isBlockSlot [

	^ false
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> isRoot: aBoolean [
	" can choose to save this state somewhere "

	
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> name: aString [

	name := aString
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> printOn: aStream [

	self printPrefixOn: aStream.
	aStream nextPut: $(.
	self printTitleOn: aStream.
	aStream nextPut: $)
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> printPrefixOn: aStream [

	SBToggledCode comment: '' active: 0 do: {[aStream nextPutAll: self className]}
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> printQualifiersOn: aStream [

	self multiple ifTrue: [aStream nextPutAll: ',multiple'].
	self required not ifTrue: [aStream nextPutAll: ',optional']
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> printTitleOn: aStream [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> takeFrom: aCursor for: aMorph [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> triggersFor: aString matchFullToken: aBoolean do: aBlock [

	^ self subclassResponsibility
]
