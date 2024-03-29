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
		'previousIndex',
		'title',
		'secondaryInsertPosition'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBRelInsertCommand >> adjacent [

	^ adjacent
]

{ #category : #'as yet unclassified' }
SBRelInsertCommand >> adjacent: aMorph [

	adjacent := aMorph
]

{ #category : #'as yet unclassified' }
SBRelInsertCommand >> before [

	^ before
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
		ifNil: [container addMorph: morph asElementNumber: self insertIndex].
	self applyPositionTo: morph in: container.
	
	^ select ifNil: [morph containingSandblock]
]

{ #category : #'as yet unclassified' }
SBRelInsertCommand >> hasSamePositionAs: aCommand [

	^ aCommand class ~= SBCombinedCommand and: [self container = aCommand container and: [self insertIndex = aCommand insertIndex]]
]

{ #category : #'as yet unclassified' }
SBRelInsertCommand >> index [

	^ self insertIndex
]

{ #category : #'as yet unclassified' }
SBRelInsertCommand >> insertIndex [

	self adjacent ifNil: [^ self before ifTrue: [1] ifFalse: [self container submorphCount + 1]].
	^ (self container submorphs indexOf: self adjacent) + (self before ifTrue: [0] ifFalse: [1]) max: 1
]

{ #category : #'as yet unclassified' }
SBRelInsertCommand >> isInsert [

	^ true
]

{ #category : #'as yet unclassified' }
SBRelInsertCommand >> isJumpPoint [

	^ self container containingSandblock hasChildSandblocks not
]

{ #category : #'as yet unclassified' }
SBRelInsertCommand >> isStatementInsert [

	self flag: #fixme.
	"not a good solution"
	^ title = 'insert statement'
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
SBRelInsertCommand >> secondaryInsertPosition [

	^ secondaryInsertPosition ifNil: [false]
]

{ #category : #'as yet unclassified' }
SBRelInsertCommand >> secondaryInsertPosition: aBoolean [

	secondaryInsertPosition := aBoolean
]

{ #category : #'as yet unclassified' }
SBRelInsertCommand >> select: aBlock [

	select := aBlock
]

{ #category : #'as yet unclassified' }
SBRelInsertCommand >> setArtefactFrom [

	^ container
]

{ #category : #'as yet unclassified' }
SBRelInsertCommand >> title [

	^ title ifNil: [super title]
]

{ #category : #'as yet unclassified' }
SBRelInsertCommand >> title: aString [

	title := aString
]

{ #category : #'as yet unclassified' }
SBRelInsertCommand >> undo [

	container removeMorph: morph.
	previousOwner ifNotNil: [previousOwner addMorph: morph asElementNumber: previousIndex].
	
	^ adjacent ifNil: container
]
