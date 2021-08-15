Class {
	#name : #SBMetaSlotBlock,
	#superclass : #SBMetaSlot,
	#instVars : [
		'structure'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBMetaSlotBlock class >> topLevel: aTypeString [

	^ self one structure: (JsonObject fromAssociations: {'type' -> 'SYMBOL'. 'name' -> aTypeString})
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> buildFor: aMorph [

	| block |
	self objectInterface ifNotNil: [^ aMorph addMorphBack: (aMorph factory unknownFor: self)].
	
	block := SBMetaBlock new factory: aMorph factory grammarRule: structure slot: self.
	aMorph addMorphBack: (self buildFor: aMorph structure: structure)
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> buildFor: aMorph structure: anObject [

	^ anObject type caseOf: {
		['STRING'] -> [aMorph addMorphBack: (SBStringMorph new contents: anObject value)].
		['SYMBOL'] -> [aMorph addMorphBack: (aMorph factory buildRule: anObject name)].
		['SEQ'] -> [anObject members withIndexDo: [:member | self buildFor: aMorph structure: member]].
		['FIELD'] -> [self buildFor: aMorph structure: anObject content]}
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> hasSameStructureAs: aSlot [

	^ aSlot isBlockSlot and: [self deepCompare: self structure to: aSlot structure]
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> isBlockSlot [

	^ true
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> matchesMorph: aMorph in: aFactory [

	self objectInterface ifNotNil: [^ aFactory type: aMorph objectInterface compatibleWith: self objectInterface].
	
	^ self matchesMorph: aMorph in: aFactory structure: structure
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> matchesMorph: aMorph in: aFactory structure: anObject [

	^ anObject type caseOf: {
		['STRING'] -> [aMorph contents = anObject value].
		['SYMBOL'] -> [aFactory type: aMorph objectInterface compatibleWith: anObject name].
		['SEQ'] -> [
			anObject members size = aMorph submorphs size ifFalse: [^ false].
			anObject members
				with: aMorph submorphs
				do: [:member :morph | (self matchesMorph: morph in: aFactory structure: member) ifFalse: [^ false]].
			true].
		['FIELD'] -> [self matchesMorph: aMorph in: aFactory structure: anObject content]}
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
SBMetaSlotBlock >> structure [

	^ structure
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> structure: anObject [

	structure := anObject
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> takeFrom: aCursor for: aMorph [

	| block |
	self objectInterface ifNotNil: [
		^ (aCursor factory type: aCursor type compatibleWith: self objectInterface)
			ifTrue: [
				aMorph addMorphBack: (aCursor buildMorphFor: self).
				true]
			ifFalse: [false]].
	
	block := SBMetaBlock new factory: aCursor factory grammarRule: structure slot: self.
	^ (self takeFrom: aCursor for: block structure: structure)
		ifTrue: [
			aMorph addMorphBack: block.
			true]
		ifFalse: [false]
]

{ #category : #'as yet unclassified' }
SBMetaSlotBlock >> takeFrom: aCursor for: aMorph structure: anObject [

	^ anObject type caseOf: {
		['STRING'] -> [
			aCursor text = anObject value
				ifTrue: [
					aMorph addMorphBack: (SBStringMorph new contents: anObject value).
					true]
				ifFalse: [false]].
		['SYMBOL'] -> [
			(aCursor factory type: aCursor type compatibleWith: anObject name)
				ifTrue: [
					aMorph addMorphBack: (aCursor buildMorphFor: (SBMetaSlotBlock topLevel: aCursor type)).
					true]
				ifFalse: [false]].
		['SEQ'] -> [ | restore |
			restore := aCursor createRestorePoint.
			anObject members withIndexDo: [:member :index |
				(self takeFrom: aCursor for: aMorph structure: member)
					ifTrue: [index < anObject members size ifTrue: [aCursor gotoNextSibling]]
					ifFalse: [
						aCursor restoreTo: restore.
						^ false]].
			true].
		['CHOICE'] -> [
			anObject members do: [:choice | | restore |
				restore := aCursor createRestorePoint.
				(self takeFrom: aCursor for: aMorph structure: choice)
					ifTrue: [^ true]
					ifFalse: [aCursor restoreTo: restore]].
			false].
		['REPEAT'] -> [ | cursorHasNext restore |
			cursorHasNext := true.
			[cursorHasNext and: [self takeFrom: aCursor for: aMorph structure: anObject content]] whileTrue: [
				restore := aCursor createRestorePoint.
				cursorHasNext := aCursor gotoNextSibling].
			restore ifNotNil: [" contract is to end before our last confumed item "
			aCursor restoreTo: restore].
			true].
		['FIELD'] -> [self takeFrom: aCursor for: aMorph structure: anObject content]}
]
