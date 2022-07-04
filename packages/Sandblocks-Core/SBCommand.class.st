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

{ #category : #'insert helper' }
SBCommand class >> boundsWithSize: aSizeNumber in: aBlock index: aNumber horizontal: aBoolean [

	| inset |
	^ aBlock hasHorizontalLayout
		ifTrue: [
			aBlock hasSubmorphs
				ifFalse: [ | height |
					inset := aBlock layoutInset asEdgeInsets.
					height := aBlock height max: TextStyle defaultFont height // 2.
					aBlock topLeft + inset topLeft - (aSizeNumber // 2 @ 0) extent: aSizeNumber @ (height - inset vertical)]
				ifTrue: [ | adjacent before |
					adjacent := aNumber > 1
						ifTrue: [aBlock submorphs at: aNumber - 1]
						ifFalse: [aBlock firstSubmorph].
					before := aNumber = 1.
					before
						ifTrue: [adjacent topLeft - (aSizeNumber // 2 @ 0) extent: aSizeNumber @ adjacent height]
						ifFalse: [adjacent topRight extent: aSizeNumber @ adjacent height]]]
		ifFalse: [
			aBlock hasSubmorphs
				ifFalse: [
					inset := aBlock layoutInset asEdgeInsets.
					"if we are in an empty container with vertical layout, we may get a 1x1 sized cursor. Scale it to be the font's height instead."
					aBlock width - inset x < 5
						ifTrue: [aBlock topLeft + inset topLeft extent: aSizeNumber @ TextStyle defaultFont height]
						ifFalse: [aBlock topLeft + inset topLeft extent: aBlock width - inset horizontal @ aSizeNumber]]
				ifTrue: [ | adjacent before |
					adjacent := aNumber > aBlock submorphCount
						ifTrue: [aBlock lastSubmorph]
						ifFalse: [aBlock submorphs at: aNumber].
					before := aNumber <= aBlock submorphCount.
					before
						ifTrue: [adjacent topLeft - (0 @ (aSizeNumber // 2)) extent: adjacent width @ aSizeNumber]
						ifFalse: [adjacent bottomLeft extent: adjacent width @ aSizeNumber]]]
]

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
SBCommand >> canInsert: aBlock do: aClosure [
	"return true if this an insert command for which aBlock would have been a valid insertion and return the morph or an adapted block via the closure"

	^ false
]

{ #category : #'insert commands' }
SBCommand >> container [

	^ nil
]

{ #category : #'insert commands' }
SBCommand >> continueAfterInsert: aCharacter [
	" mark that if this command has been used as an insertion point, the input should be forward to the new block "

	^ true
]

{ #category : #apply }
SBCommand >> do [

	^ self subclassResponsibility
]

{ #category : #'insert commands' }
SBCommand >> hasHorizontalLayout [
	"used by insert commands to communicate the layout direction"

	^ self container hasHorizontalLayout
]

{ #category : #'insert commands' }
SBCommand >> hasSamePositionAs: aCommand [

	^ false
]

{ #category : #'initialize-release' }
SBCommand >> initialize [

	super initialize.
	
	shouldMergeWithNext :=  false.
	wasEdit := true
]

{ #category : #'insert commands' }
SBCommand >> insertBounds [

	^ self insertBoundsWithSize: 3
]

{ #category : #'insert commands' }
SBCommand >> insertBoundsWithSize: aNumber [

	^ self container
		ifNotNil: [:c |
			self class
				boundsWithSize: aNumber
				in: c
				index: self insertIndex
				horizontal: self hasHorizontalLayout]
		ifNil: [0 @ 0 extent: 0 @ 0]
]

{ #category : #'insert commands' }
SBCommand >> insertBoundsWithSize: aNumber near: aPoint [

	^ self container
		ifNotNil: [:c |
			self class
				boundsWithSize: aNumber
				in: c
				index: self insertIndex
				horizontal: self hasHorizontalLayout]
		ifNil: [0 @ 0 extent: 0 @ 0]
]

{ #category : #'insert commands' }
SBCommand >> insertIndex [

	^ 1
]

{ #category : #'insert commands' }
SBCommand >> isInsert [

	^ false
]

{ #category : #testing }
SBCommand >> isStatementInsert [

	^ false
]

{ #category : #'insert commands' }
SBCommand >> minimalInsertBounds [

	^ self insertBoundsWithSize: 1
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

{ #category : #'insert commands' }
SBCommand >> secondaryInsertPosition [
	"if this is an insert command, you can return true here to tell the cursor that this position should not receive default focus, even if it comes first in the container"

	^ false
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
SBCommand >> suggestions [
	"used by insert commands, return a list of suggestion items here"

	^ #()
]

{ #category : #accessing }
SBCommand >> title [

	^ nil
]

{ #category : #'insert commands' }
SBCommand >> tryExpandWithInput: aString [
	"check if the given input is acceptable for this insert command and return an according boolean. if it is, you may already adapt the command according to the input."

	^ true
]

{ #category : #apply }
SBCommand >> undo [

	^ self subclassResponsibility
]

{ #category : #testing }
SBCommand >> valid [

	^ true
]
