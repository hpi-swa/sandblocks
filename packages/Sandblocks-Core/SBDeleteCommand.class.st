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
	nextSelection := target containingSandblock focusAfterDeleteIfNone: [self nextBlockFrom: target].
	oldOwner := target owner.
	oldIndex := oldOwner submorphIndexOf: target.
	oldOwner removeMorph: target.
	
	^ nextSelection isInEditor ifTrue: [nextSelection] ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBDeleteCommand >> nextBlockFrom: aMorph [

	| next m |
	m := aMorph firstBlock ifNil: [aMorph containingSandblock].
	
	m floating ifTrue: [
		^ (m parentSandblock
			childClosestTo: (m center ifNil: [m sandblockEditor])
			that: [:b | b ~= m]) ifNil: [m sandblockEditor]].
	
	next := (aMorph isSandblock
		ifTrue: [(aMorph adjacentBlock: 1) ifNil: [aMorph adjacentBlock: -1]]
		ifFalse: [
			aMorph childSandblocks
				ifNotEmpty: [:blocks | (blocks first adjacentBlock: -1) ifNil: [blocks last adjacentBlock: 1]]
				ifEmpty: [(aMorph containingSandblock adjacentBlock: -1) ifNil: [aMorph containingSandblock adjacentBlock: 1]]]) ifNil: [aMorph containingSandblock parentSandblock].
	
	^ (next isNil or: [next containingFloat ~= aMorph containingFloat])
		ifTrue: [aMorph sandblockEditor]
		ifFalse: [next]
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
