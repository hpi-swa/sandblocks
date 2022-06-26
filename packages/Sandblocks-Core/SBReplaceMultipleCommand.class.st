Class {
	#name : #SBReplaceMultipleCommand,
	#superclass : #SBCommand,
	#instVars : [
		'targetOldOwner',
		'target',
		'targetOldIndex',
		'replacers'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBReplaceMultipleCommand >> do [

	targetOldOwner := target owner.
	targetOldIndex := targetOldOwner submorphIndexOf: target.
	target owner removeMorph: target.
	replacers withIndexDo: [:replacer :index | targetOldOwner addMorph: replacer asElementNumber: targetOldIndex + (index - 1)].
	^ replacers first containingSandblock
]

{ #category : #'as yet unclassified' }
SBReplaceMultipleCommand >> morphs [

	^ replacers
]

{ #category : #'as yet unclassified' }
SBReplaceMultipleCommand >> replacers: aCollection [

	replacers := aCollection
]

{ #category : #'as yet unclassified' }
SBReplaceMultipleCommand >> setArtefactFrom [

	^ target
]

{ #category : #'as yet unclassified' }
SBReplaceMultipleCommand >> target: aMorph [

	target := aMorph
]

{ #category : #'as yet unclassified' }
SBReplaceMultipleCommand >> target: aBlock replacers: aCollection [

	self target: aBlock.
	self replacers: aCollection
]

{ #category : #'as yet unclassified' }
SBReplaceMultipleCommand >> undo [

	replacers do: #delete.
	targetOldOwner addMorph: target asElementNumber: targetOldIndex.
	^ target
]
