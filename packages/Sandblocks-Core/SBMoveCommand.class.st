Class {
	#name : #SBMoveCommand,
	#superclass : #SBCommand,
	#instVars : [
		'container',
		'morph',
		'index',
		'oldOwner',
		'oldIndex'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBMoveCommand >> container: aMorph [

	container := aMorph
]

{ #category : #'as yet unclassified' }
SBMoveCommand >> do [

	oldOwner ifNil: [
		oldOwner := morph owner.
		oldIndex := oldOwner submorphIndexOf: morph].
	container addMorph: morph asElementNumber: index.
	^ morph
]

{ #category : #'as yet unclassified' }
SBMoveCommand >> index [

	^ index
]

{ #category : #'as yet unclassified' }
SBMoveCommand >> index: aNumber [

	index := aNumber
]

{ #category : #'as yet unclassified' }
SBMoveCommand >> morph: aMorph [

	morph := aMorph
]

{ #category : #'as yet unclassified' }
SBMoveCommand >> notePosition [

	self artefactFrom: self setArtefactFrom.
	oldOwner := morph owner.
	oldIndex := oldOwner submorphIndexOf: morph
]

{ #category : #'as yet unclassified' }
SBMoveCommand >> setArtefactFrom [

	^ morph
]

{ #category : #'as yet unclassified' }
SBMoveCommand >> undo [

	container removeMorph: morph.
	oldOwner addMorph: morph asElementNumber: oldIndex.
	^ morph
]
