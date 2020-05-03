Class {
	#name : #SBReplaceConsecutiveCommand,
	#superclass : #SBCommand,
	#instVars : [
		'replacer',
		'targets',
		'targetOldOwner',
		'targetOldIndex',
		'replacerOldOwner',
		'replacerOldIndex'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBReplaceConsecutiveCommand >> affectedMorphs [

	^ targets, {replacerOldOwner ifNil: [replacer owner]} select: #notNil
]

{ #category : #'as yet unclassified' }
SBReplaceConsecutiveCommand >> do [

	targetOldOwner := targets first owner.
	targetOldIndex := targetOldOwner submorphIndexOf: targets first.
	
	replacerOldOwner := replacer owner.
	replacerOldOwner ifNotNil: [
		replacerOldIndex := replacerOldOwner submorphIndexOf: replacer].
	
	targets do: #delete.
	replacerOldOwner ifNotNil: [:o | o removeMorph: replacer].
	targetOldOwner addMorph: replacer asElementNumber: targetOldIndex.
	
	^ replacer
]

{ #category : #'as yet unclassified' }
SBReplaceConsecutiveCommand >> replacer: aMorph [

	replacer := aMorph
]

{ #category : #'as yet unclassified' }
SBReplaceConsecutiveCommand >> targets: aCollectionOfMorph [

	targets := aCollectionOfMorph
]

{ #category : #'as yet unclassified' }
SBReplaceConsecutiveCommand >> undo [

	replacer owner removeMorph: replacer.
	targets withIndexDo: [:target :index |
		targetOldOwner addMorph: target asElementNumber: targetOldIndex + index - 1].
	
	replacerOldOwner ifNotNil: [
		replacerOldOwner addMorph: replacer asElementNumber: replacerOldIndex].
	
	^ replacer owner ifNotNil: [replacer] ifNil: [targets first]
]
