Class {
	#name : #SBWrapConsecutiveCommand,
	#superclass : #SBCommand,
	#instVars : [
		'outer',
		'wrap',
		'targets',
		'targetOldOwner',
		'targetOldIndex',
		'wrapUndo'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBWrapConsecutiveCommand >> do [

	targetOldOwner := targets first owner.
	targetOldIndex := targetOldOwner submorphIndexOf: targets first.
	
	targets first replaceBy: outer.
	wrap value: outer value: targets.
	^ targets first
]

{ #category : #'as yet unclassified' }
SBWrapConsecutiveCommand >> outer: aMorph [

	outer := aMorph
]

{ #category : #'as yet unclassified' }
SBWrapConsecutiveCommand >> setArtefactFrom [

	^ targets first
]

{ #category : #'as yet unclassified' }
SBWrapConsecutiveCommand >> targets: aCollection [

	targets := aCollection
]

{ #category : #'as yet unclassified' }
SBWrapConsecutiveCommand >> undo [

	wrapUndo ifNotNil: [wrapUndo value: outer value: targets].
	
	outer replaceBy: targets first.
	
	targets viewAllButFirst withIndexDo: [:target :index |
		targetOldOwner addMorph: target asElementNumber: targetOldIndex + index].
	
	^ targets first
]

{ #category : #'as yet unclassified' }
SBWrapConsecutiveCommand >> wrap: anObject [

	wrap := anObject
]

{ #category : #'as yet unclassified' }
SBWrapConsecutiveCommand >> wrapUndo: aBlock [

	wrapUndo := aBlock
]
