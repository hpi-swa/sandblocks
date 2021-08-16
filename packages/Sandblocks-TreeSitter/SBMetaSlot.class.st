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
SBMetaSlot >> = aSlot [

	^ self class = aSlot class and: [self required = aSlot required and: [self multiple = aSlot multiple]]
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

	^ multiple hash bitXor: required hash
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
SBMetaSlot >> morphsIn: aStream factory: aFactory do: aBlock [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> morphsRepeatedIn: aStream factory: aFactory do: aBlock [

	| count restore morphs |
	count := 0.
	restore := aStream position.
	morphs := OrderedCollection new.
	[aStream atEnd not and: [(self multiple or: [count = 0]) and: [self morphsIn: aStream factory: aFactory do: aBlock]]] whileTrue: [
		count := count + 1.
		restore := aStream position.
		aStream next].
	aStream position: restore.
	
	(self required not and: [count = 0]) ifTrue: [aBlock value: self value: #()].
	
	^ self required not or: [count > 0]
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

	self printPrefixOn: aStream.
	aStream nextPut: $(.
	self printTitleOn: aStream.
	self printQualifiersOn: aStream.
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

{ #category : #'as yet unclassified' }
SBMetaSlot >> takeRepeatedFrom: aCursor for: aMorph [

	| count cursorHasNext restore |
	count := 0.
	cursorHasNext := true.
	restore := aCursor createRestorePoint.
	[cursorHasNext and: [(self multiple or: [count = 0]) and: [self takeFrom: aCursor for: aMorph]]] whileTrue: [
		count := count + 1.
		restore := aCursor createRestorePoint.
		cursorHasNext := aCursor gotoNextSibling].
	aCursor restoreTo: restore.
	
	^ self required not or: [count > 0]
]

{ #category : #'as yet unclassified' }
SBMetaSlot >> triggersFor: aString matchFullToken: aBoolean do: aBlock [

	^ self subclassResponsibility
]
