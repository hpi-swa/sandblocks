Class {
	#name : #SBCommand,
	#superclass : #Object,
	#instVars : [
		'shouldMergeWithNext',
		'wasEdit',
		'artefact',
		'previousSelection'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCommand class >> new [

	^ self error: 'use newFor:'
]

{ #category : #'as yet unclassified' }
SBCommand class >> newFor: anArtefact [

	self assert: anArtefact notNil.
	
	^ self basicNew initialize
		artefact: anArtefact;
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

	^ {self artefact}
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
SBCommand >> postDo [

	" you may do any action here after the 'do' has completed that does not affect any state that should be undo-able, e.g. you may move focus to a specific part here "
]

{ #category : #'as yet unclassified' }
SBCommand >> previousSelection [

	^ previousSelection
]

{ #category : #'as yet unclassified' }
SBCommand >> previousSelection: aBlock [

	previousSelection := aBlock
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
