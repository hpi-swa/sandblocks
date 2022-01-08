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

	self deprecated: 'please use #new directly. You can set artefacts explicitly via artefact: if needed'.
	^ self basicNew initialize
		artefact: anArtefactOrNil;
		yourself
]

{ #category : #'as yet unclassified' }
SBCommand class >> newNonEdit [

	self deprecated: 'please use #new directly. You can set artefacts explicitly via artefact: if needed'.
	^ self basicNew initialize yourself
]

{ #category : #'as yet unclassified' }
SBCommand class >> newOrEditFor: anArtefactOrNil [

	self deprecated: 'please use #new directly. You can set artefacts explicitly via artefact: if needed'.
	^ self basicNew initialize
		artefact: anArtefactOrNil;
		yourself
]

{ #category : #accessing }
SBCommand >> affectedArtefacts [

	^ self artefact ifNotNil: [{self artefact}] ifNil: [#()]
]

{ #category : #apply }
SBCommand >> applyPositionTo: aMorphOrCollection in: anOwner [

	self position ifNil: [^ self].
	
	aMorphOrCollection isCollection
		ifTrue: [aMorphOrCollection do: [:morph | self applyPositionTo: morph in: anOwner]]
		ifFalse: [
			aMorphOrCollection position: self position.
			aMorphOrCollection isSandblock ifTrue: [
				aMorphOrCollection
					withDecorator: SBForceMoveDecorator
					do: [:d | d createImplicitForces]
					ifAbsent: []]]
]

{ #category : #accessing }
SBCommand >> artefact [

	^ artefact
]

{ #category : #accessing }
SBCommand >> artefact: anObject [

	artefact := anObject
]

{ #category : #apply }
SBCommand >> artefactFrom: aMorph [

	aMorph ifNotNil: [
		self artefact: aMorph containingSandblock containingArtefact]
]

{ #category : #testing }
SBCommand >> continueAfterInsert: aCharacter [
	" mark that if this command has been used as an insertion point, the input should be forward to the new block "

	^ true
]

{ #category : #apply }
SBCommand >> do [

	^ self subclassResponsibility
]

{ #category : #'initialize-release' }
SBCommand >> initialize [

	super initialize.
	
	shouldMergeWithNext :=  false.
	wasEdit := true
]

{ #category : #accessing }
SBCommand >> position [
	" if set, the position where new morphs should be placed "

	^ position
]

{ #category : #accessing }
SBCommand >> position: aPoint [

	position := aPoint
]

{ #category : #apply }
SBCommand >> postDo [

	" you may do any action here after the 'do' has completed that does not affect any state that should be undo-able, e.g. you may move focus to a specific part here "
]

{ #category : #apply }
SBCommand >> preDo [

	artefact ifNil: [self artefactFrom: self setArtefactFrom]
]

{ #category : #accessing }
SBCommand >> previousSelection [

	^ previousSelection
]

{ #category : #accessing }
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

{ #category : #accessing }
SBCommand >> setArtefactFrom [

	^ self subclassResponsibility
]

{ #category : #accessing }
SBCommand >> shouldMergeWithNext [

	^ shouldMergeWithNext
]

{ #category : #accessing }
SBCommand >> shouldMergeWithNext: aBoolean [

	shouldMergeWithNext := aBoolean
]

{ #category : #accessing }
SBCommand >> title [

	^ nil
]

{ #category : #apply }
SBCommand >> undo [

	^ self subclassResponsibility
]

{ #category : #testing }
SBCommand >> valid [

	^ true
]
