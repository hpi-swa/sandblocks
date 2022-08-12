Class {
	#name : #SBInsertCommand,
	#superclass : #SBCommand,
	#instVars : [
		'index',
		'morph',
		'container',
		'select',
		'title'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBInsertCommand >> container [

	^ container
]

{ #category : #'as yet unclassified' }
SBInsertCommand >> container: aMorph [

	container := aMorph
]

{ #category : #apply }
SBInsertCommand >> do [

	container addMorph: morph asElementNumber: index.
	self applyPositionTo: morph in: container.
	^ select ifNil: [morph]
]

{ #category : #'insert commands' }
SBInsertCommand >> hasSamePositionAs: aCommand [

	^ aCommand class ~= SBCombinedCommand and: [self container = aCommand container and: [self index = aCommand index]]
]

{ #category : #'as yet unclassified' }
SBInsertCommand >> index [

	^ index
]

{ #category : #'as yet unclassified' }
SBInsertCommand >> index: aNumber [

	index := aNumber
]

{ #category : #'insert commands' }
SBInsertCommand >> insertBoundsWithSize: aNumber [

	
]

{ #category : #'as yet unclassified' }
SBInsertCommand >> insertIndex [

	^ index
]

{ #category : #'as yet unclassified' }
SBInsertCommand >> isInsert [

	^ true
]

{ #category : #'as yet unclassified' }
SBInsertCommand >> isJumpPoint [

	^ self container containingSandblock childSandblocks not
]

{ #category : #'as yet unclassified' }
SBInsertCommand >> morph [

	^ morph
]

{ #category : #'as yet unclassified' }
SBInsertCommand >> morph: aMorph [

	morph := aMorph
]

{ #category : #'as yet unclassified' }
SBInsertCommand >> select: aBlock [

	select := aBlock
]

{ #category : #accessing }
SBInsertCommand >> setArtefactFrom [

	^ container
]

{ #category : #accessing }
SBInsertCommand >> title [

	^ title
]

{ #category : #'as yet unclassified' }
SBInsertCommand >> title: aString [

	title := aString
]

{ #category : #apply }
SBInsertCommand >> undo [

	| parentBlock |
	index := container submorphIndexOf: morph.
	container removeMorph: morph.
	
	parentBlock := container containingSandblock.
	^ (parentBlock childSandblocks notEmpty and: [index notNil])
		ifTrue: [parentBlock childSandblocks at: (index clampLow: 1 high: parentBlock childSandblocks size)]
		ifFalse: [nil]
]
