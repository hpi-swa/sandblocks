Class {
	#name : #SBSubtreeRotateCommand,
	#superclass : #SBCommand,
	#instVars : [
		'target',
		'undoTarget'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBSubtreeRotateCommand >> do [

	undoTarget := target parentSandblock.
	^ self rotateAround: target
]

{ #category : #'as yet unclassified' }
SBSubtreeRotateCommand >> rotateAround: aTargetNode [

	| child childInsertIndex parent childInsertOwner isLeft |
	parent := aTargetNode parentSandblock.
	isLeft := aTargetNode isLastChild.
	child := isLeft ifTrue: [aTargetNode childSandblocks first] ifFalse: [aTargetNode childSandblocks last].
	childInsertOwner := aTargetNode owner.
	childInsertIndex := childInsertOwner submorphIndexOf: aTargetNode.
	
	parent replaceBy: aTargetNode.
	child replaceBy: parent.
	childInsertOwner addMorph: child asElementNumber: childInsertIndex.
	^ parent
]

{ #category : #'as yet unclassified' }
SBSubtreeRotateCommand >> target: aBlock [

	target := aBlock
]

{ #category : #'as yet unclassified' }
SBSubtreeRotateCommand >> undo [

	^ self rotateAround: undoTarget
]
