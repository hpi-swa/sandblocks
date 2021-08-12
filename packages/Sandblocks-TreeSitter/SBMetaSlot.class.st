Class {
	#name : #SBMetaSlot,
	#superclass : #Object,
	#instVars : [
		'type',
		'required',
		'multiple',
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
SBMetaSlot >> multiple [

	^ multiple
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> multiple: aBoolean [

	multiple := aBoolean
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> name: aString [

	name := aString
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> objectInterface [

	^ type type = 'SYMBOL' ifTrue: [type name] ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> printOn: aStream [

	aStream nextPutAll: self className.
	aStream nextPut: $(.
	aStream nextPutAll: (self objectInterface ifNotNil: [:o | o] ifNil: ['<none>']).
	self multiple ifTrue: [aStream nextPutAll: ',multiple'].
	self required ifTrue: [aStream nextPutAll: ',required'].
	aStream nextPut: $)
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> required [

	^ required
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> required: aBoolean [

	required := aBoolean
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> type [

	^ type
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> type: aType [

	type := aType
]
