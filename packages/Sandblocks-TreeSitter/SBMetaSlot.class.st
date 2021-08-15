Class {
	#name : #SBMetaSlot,
	#superclass : #Object,
	#instVars : [
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
SBMetaSlot >> buildFor: aMorph [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> deepCompare: anObject to: anotherObject [

	anObject associationsDo: [:assoc | | obj |
		obj := anotherObject at: assoc key ifAbsent: [^ false].
		((obj isDictionary and: [assoc value isDictionary])
			ifTrue: [self deepCompare: assoc value to: obj]
			ifFalse: [obj = assoc value]) ifFalse: [^ false]].
	^ true
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> isBlockSlot [

	^ false
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> matchesMorph: aMorph in: aFactory [

	^ self subclassResponsibility
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
SBMetaSlot >> printOn: aStream [

	self subclassResponsibility
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
SBMetaSlot >> takeFrom: aCursor for: aMorph [

	^ self subclassResponsibility
]
