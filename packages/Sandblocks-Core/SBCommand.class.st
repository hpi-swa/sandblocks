Class {
	#name : #SBCommand,
	#superclass : #Object,
	#instVars : [
		'shouldMergeWithNext',
		'wasEdit',
		'artefact',
		'previousSelection',
		'position',
		'selectAfter'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCommand class >> newFor: anArtefactOrNil [

	^ self basicNew initialize
		artefact: anArtefactOrNil;
		yourself
]

{ #category : #'as yet unclassified' }
SBCommand class >> newNonEdit [

	^ self basicNew initialize
		wasEdit: false;
		yourself
]

{ #category : #'as yet unclassified' }
SBCommand class >> newOrEditFor: anArtefactOrNil [

	^ self basicNew initialize
		artefact: anArtefactOrNil;
		wasEdit: anArtefactOrNil notNil;
		yourself
]

{ #category : #'as yet unclassified' }
SBCommand >> affectedArtefacts [

	^ self artefact ifNotNil: [{self artefact}] ifNil: [#()]
]

{ #category : #'as yet unclassified' }
SBCommand >> applyPositionTo: aMorphOrCollection [

	self position ifNil: [^ self].
	
	aMorphOrCollection isCollection
		ifTrue: [aMorphOrCollection do: [:morph | self applyPositionTo: morph]]
		ifFalse: [aMorphOrCollection position: self position]
]

{ #category : #'as yet unclassified' }
SBCommand >> artefact [

	^ artefact
]

{ #category : #'as yet unclassified' }
SBCommand >> artefact: anObject [

	artefact := anObject
]

{ #category : #apply }
SBCommand >> artefactFrom: aMorph [

	aMorph ifNotNil: [
		self artefact: aMorph containingSandblock containingArtefact]
]

{ #category : #apply }
SBCommand >> do [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBCommand >> initialize [

	super initialize.
	
	shouldMergeWithNext :=  false.
	wasEdit := true
]

{ #category : #'as yet unclassified' }
SBCommand >> position [
	" if set, the position where new morphs should be placed "

	^ position
]

{ #category : #'as yet unclassified' }
SBCommand >> position: aPoint [

	position := aPoint
]

{ #category : #'as yet unclassified' }
SBCommand >> postDo [

	" you may do any action here after the 'do' has completed that does not affect any state that should be undo-able, e.g. you may move focus to a specific part here "
]

{ #category : #'as yet unclassified' }
SBCommand >> preDo [

	artefact ifNil: [self artefactFrom: self setArtefactFrom]
]

{ #category : #'as yet unclassified' }
SBCommand >> previousSelection [

	^ previousSelection
]

{ #category : #'as yet unclassified' }
SBCommand >> previousSelection: aBlock [

	previousSelection := aBlock
]

{ #category : #apply }
SBCommand >> selectAfter [

	^ selectAfter
]

{ #category : #apply }
SBCommand >> selectAfter: aBlock [
	" you may set this to #none to mark that no other block should be selected after this command.
 Leave nil to use the default behavior of selecting the return value of do/undo"

	selectAfter := aBlock
]

{ #category : #'as yet unclassified' }
SBCommand >> setArtefactFrom [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBCommand >> shouldMergeWithNext [

	^ shouldMergeWithNext
]

{ #category : #'as yet unclassified' }
SBCommand >> shouldMergeWithNext: aBoolean [

	shouldMergeWithNext := aBoolean
]

{ #category : #apply }
SBCommand >> undo [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBCommand >> valid [

	^ true
]

{ #category : #'as yet unclassified' }
SBCommand >> wasEdit [

	^ wasEdit
]

{ #category : #'as yet unclassified' }
SBCommand >> wasEdit: aBoolean [

	wasEdit := aBoolean
]
