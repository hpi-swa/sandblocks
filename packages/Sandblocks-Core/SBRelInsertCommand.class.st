Class {
	#name : #SBRelInsertCommand,
	#superclass : #SBCommand,
	#instVars : [
		'adjacent',
		'before',
		'morph',
		'container',
		'select',
		'previousOwner',
		'previousIndex'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBRelInsertCommand >> adjacent: aMorph [

	adjacent := aMorph
]

{ #category : #'as yet unclassified' }
SBRelInsertCommand >> before: aBoolean [

	before := aBoolean
]

{ #category : #'as yet unclassified' }
SBRelInsertCommand >> container [

	^ container
]

{ #category : #'as yet unclassified' }
SBRelInsertCommand >> container: aMorph [

	container := aMorph
]

{ #category : #'as yet unclassified' }
SBRelInsertCommand >> do [

	previousOwner := morph owner.
	previousIndex := previousOwner ifNotNil: [:o | o submorphs indexOf: morph].
	
	adjacent
		ifNotNil: [
			before
				ifTrue: [container addMorph: morph inFrontOf: adjacent]
				ifFalse: [container addMorph: morph behind: adjacent]]
		ifNil: [container addMorphBack: morph].
	
	^ select ifNil: [morph]
]

{ #category : #'as yet unclassified' }
SBRelInsertCommand >> morph [

	^ morph
]

{ #category : #'as yet unclassified' }
SBRelInsertCommand >> morph: aMorph [

	morph := aMorph
]

{ #category : #'as yet unclassified' }
SBRelInsertCommand >> near: aBlock before: aBoolean in: aContainer morph: aMorph [

	adjacent := aBlock.
	before := aBoolean.
	container := aContainer.
	morph := aMorph
]

{ #category : #'as yet unclassified' }
SBRelInsertCommand >> select: aBlock [

	select := aBlock
]

{ #category : #'as yet unclassified' }
SBRelInsertCommand >> undo [

	container removeMorph: morph.
	previousOwner ifNotNil: [previousOwner addMorph: morph asElementNumber: previousIndex].
	
	^ adjacent ifNil: container
]
