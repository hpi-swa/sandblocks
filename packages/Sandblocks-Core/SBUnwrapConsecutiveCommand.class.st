Class {
	#name : #SBUnwrapConsecutiveCommand,
	#superclass : #SBCommand,
	#instVars : [
		'target',
		'unwrapped',
		'oldPositions'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBUnwrapConsecutiveCommand >> do [

	unwrapped := target childSandblocks.
	oldPositions := unwrapped collect: [:m | {m owner. m submorphIndex}].
	
	target owner addAllMorphs: unwrapped after: target.
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
	oldPositions
		with: unwrapped
		do: [:pos :morph | pos first addMorph: morph asElementNumber: pos second].
	^ target
]
