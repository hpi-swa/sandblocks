Class {
	#name : #SBMetaSlotChoice,
	#superclass : #SBMetaSlot,
	#instVars : [
		'alternatives'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBMetaSlotChoice >> = aSlot [

	^ super = aSlot and: [self alternatives hasEqualElements: aSlot alternatives]
]

{ #category : #'as yet unclassified' }
SBMetaSlotChoice >> alternatives [

	^ alternatives
]

{ #category : #'as yet unclassified' }
SBMetaSlotChoice >> alternatives: aCollection [

	alternatives := aCollection
]

{ #category : #'as yet unclassified' }
SBMetaSlotChoice >> buildFor: aMorph [

	aMorph addMorphBack: (aMorph factory unknownFor: self)
]

{ #category : #'as yet unclassified' }
SBMetaSlotChoice >> buildPartialFor: aMorph option: anOption with: aString [

	(self alternatives at: anOption index)
		buildPartialFor: aMorph
		option: anOption children first
		with: aString
]

{ #category : #'as yet unclassified' }
SBMetaSlotChoice >> hash [

	^ alternatives hash
]

{ #category : #'as yet unclassified' }
SBMetaSlotChoice >> morphsIn: aStream do: aBlock [

	self alternatives do: [:alternative | | restore |
		restore := aStream position.
		(alternative morphsIn: aStream do: [:slot :block | ])
			ifTrue: [^ alternative morphsIn: aStream do: aBlock]
			ifFalse: [aStream position: restore]].
	^ false
]

{ #category : #'as yet unclassified' }
SBMetaSlotChoice >> printTitleOn: aStream [

	alternatives do: [:alt | aStream print: alt] separatedBy: [aStream nextPut: $|]
]

{ #category : #'as yet unclassified' }
SBMetaSlotChoice >> takeFrom: aCursor for: aMorph [
	" FIXME: need to try all and pick what consumed most? "

	self alternatives do: [:choice | | restore |
		restore := aCursor createRestorePoint.
		(choice takeFrom: aCursor for: aMorph)
			ifTrue: [^ true]
			ifFalse: [aCursor restoreTo: restore]].
	^ false
]

{ #category : #'as yet unclassified' }
SBMetaSlotChoice >> triggersFor: aString matchFullToken: aBoolean do: anOption [

	| anyMatch |
	anyMatch := false.
	self alternatives withIndexDo: [:alternative :index |
		(anOption
			add: index
			if: [:option | alternative triggersFor: aString matchFullToken: aBoolean do: option]) ifTrue: [anyMatch := true]].
	^ anyMatch
]