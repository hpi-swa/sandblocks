Class {
	#name : #SBMetaSlotBlock,
	#superclass : #SBMetaSlot,
	#instVars : [
		'objectInterface',
		'structure'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> applyToMorph: block getText: aTextBlock buildChild: aBlock [

	block addMorphBack: (aBlock cull: structure)
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> isBlockSlot [

	^ true
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> matchesMorph: aMorph in: aFactory [

	^ aFactory type: aMorph objectInterface compatibleWith: self objectInterface
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> matchesNode: aNode ts: aLibrary [

	^ aLibrary currentFactory
		type: (aLibrary nodeType: aNode)
		compatibleWith: self objectInterface
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> objectInterface [

	structure type = 'SYMBOL' ifTrue: [^ structure name].
	(structure type = 'CHOICE' and: [structure members allSatisfy: [:m | m type = 'SYMBOL']]) ifTrue: [^ structure members collect: #name].
	^ nil
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> printOn: aStream [

	aStream nextPutAll: self className.
	aStream nextPut: $(.
	aStream nextPutAll: (self objectInterface isString
		ifTrue: [self objectInterface]
		ifFalse: [self objectInterface ifNotNil: [:o | o joinSeparatedBy: ','] ifNil: ['<>']]).
	self multiple ifTrue: [aStream nextPutAll: ',multiple'].
	self required ifTrue: [aStream nextPutAll: ',required'].
	aStream nextPut: $)
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> structure: anObject [

	structure := anObject
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> takeFrom: aCursor ts: aLibrary for: aMorph [

	^ self takeFrom: aCursor ts: aLibrary for: aMorph structure: structure
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> takeFrom: aCursor ts: aLibrary for: aMorph structure: anObject [

	| node |
	node := aLibrary cursorCurrentNode: aLibrary.
	^ anObject type caseOf: {
		['SYMBOL'] -> [
			(aLibrary currentFactory
				type: (aLibrary nodeType: node)
				compatibleWith: self objectInterface)
				ifTrue: [
					aMorph addMorphBack: (aLibrary buildTree: aCursor).
					aLibrary cursorGotoNextSibling: aCursor.
					true]
				ifFalse: [false]].
		['STRING'] -> [
			(aLibrary textForNode: node) = anObject value
				ifTrue: [
					" TODO: probably want this addressable "
					aMorph addMorphBack: (SBStringMorph new contents: anObject value).
					aLibrary cursorGotoNextSibling: aCursor.
					true]
				ifFalse: [false]].
		['SEQ'] -> [
			anObject members do: [:member |
				(self takeFrom: aCursor ts: aLibrary for: aMorph structure: member)
					ifTrue: [aLibrary cursorGotoNextSibling: aCursor]
					ifFalse: [
						aLibrary cursor: aCursor reset: node.
						^ false]].
			true]}
]
