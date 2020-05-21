Class {
	#name : #SBUnwrapConsecutiveCommand,
	#superclass : #SBCommand,
	#instVars : [
		'target',
		'unwrapped'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBUnwrapConsecutiveCommand >> do [

	unwrapped := target childSandblocks.
	target parentSandblock addAllMorphs: unwrapped after: target.
	target delete.
	^ unwrapped first
]

{ #category : #'as yet unclassified' }
SBUnwrapConsecutiveCommand >> target: aBlock [

	target := aBlock
]

{ #category : #'as yet unclassified' }
SBUnwrapConsecutiveCommand >> undo [

	unwrapped first replaceBy: target.
	target addAllMorphs: unwrapped.
	^ target
]
