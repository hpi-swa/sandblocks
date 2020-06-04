Class {
	#name : #SBSubtreeRotateCommand,
	#superclass : #SBCommand,
	#instVars : [
		'target',
		'undoTarget',
		'isLeft'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBSubtreeRotateCommand >> do [

	undoTarget := target parentSandblock.
	wasLeft := target isLastChild.
	^ self rotateAround: target isLeftOrNil: wasLeft
]

{ #category : #'as yet unclassified' }
SBSubtreeRotateCommand >> rotateAround: aTargetNode isLeftOrNil: aBoolean [

	| child childInsertIndex parent childInsertOwner isLeft |
	parent := aTargetNode parentSandblock.
	isLeft := aBoolean ifNil: [aTargetNode isLastChild].
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

	^ self rotateAround: undoTarget isLeftOrNil: wasLeft not
]
