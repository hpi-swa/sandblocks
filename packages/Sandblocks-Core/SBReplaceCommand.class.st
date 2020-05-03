Class {
	#name : #SBReplaceCommand,
	#superclass : #SBCommand,
	#instVars : [
		'targetOldOwner',
		'target',
		'targetOldIndex',
		'replacerOldOwner',
		'replacer',
		'replacerOldIndex'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBReplaceCommand >> do [

	targetOldOwner := target owner.
	targetOldIndex := targetOldOwner submorphIndexOf: target.
	
	replacerOldOwner := replacer owner.
	replacerOldOwner ifNotNil: [
		replacerOldIndex := replacerOldOwner submorphIndexOf: replacer].
	
	target owner removeMorph: target.
	replacerOldOwner ifNotNil: [:o | o removeMorph: replacer].
	targetOldOwner addMorph: replacer asElementNumber: targetOldIndex.
	
	^ replacer
]

{ #category : #'as yet unclassified' }
SBReplaceCommand >> replacer: aMorph [

	replacer := aMorph
]

{ #category : #'as yet unclassified' }
SBReplaceCommand >> target: aMorph [

	target := aMorph
]

{ #category : #'as yet unclassified' }
SBReplaceCommand >> undo [

	replacer owner removeMorph: replacer.
	targetOldOwner addMorph: target asElementNumber: targetOldIndex.
	replacerOldOwner ifNotNil: [
		replacerOldOwner addMorph: replacer asElementNumber: replacerOldIndex].
	
	^ replacer owner ifNotNil: [replacer] ifNil: [target]
]
