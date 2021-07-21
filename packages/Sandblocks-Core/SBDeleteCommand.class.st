Class {
	#name : #SBDeleteCommand,
	#superclass : #SBCommand,
	#instVars : [
		'target',
		'oldOwner',
		'oldIndex'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBDeleteCommand >> do [

	| nextSelection |
	nextSelection := target containingSandblock focusAfterDeleteIfNone: [target sandblockEditor].
	oldOwner := target owner.
	oldIndex := oldOwner submorphIndexOf: target.
	oldOwner removeMorph: target.
	
	^ nextSelection
]

{ #category : #'as yet unclassified' }
SBDeleteCommand >> nextBlockFrom: aMorph [

	^ (aMorph isSandblock
		ifTrue: [
			(aMorph adjacentBlock: 1) ifNil: [aMorph adjacentBlock: -1]]
		ifFalse: [
			aMorph childSandblocks
				ifNotEmpty: [:blocks |
					(blocks first adjacentBlock: -1) ifNil: [blocks last adjacentBlock: 1]]
				ifEmpty: [
					(aMorph containingSandblock adjacentBlock: -1) ifNil: [aMorph containingSandblock adjacentBlock: 1]]]) ifNil: [aMorph containingSandblock parentSandblock]
]

{ #category : #'as yet unclassified' }
SBDeleteCommand >> setArtefactFrom [

	^ target
]

{ #category : #'as yet unclassified' }
SBDeleteCommand >> target: aMorph [

	target := aMorph
]

{ #category : #'as yet unclassified' }
SBDeleteCommand >> undo [

	oldOwner addMorph: target asElementNumber: oldIndex.
	^ target containingSandblock
]
