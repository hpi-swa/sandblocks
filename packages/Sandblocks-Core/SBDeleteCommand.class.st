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
	m := aMorph isSandblock ifTrue: [aMorph] ifFalse: [aMorph firstBlock ifNil: [aMorph containingSandblock]].
	
	m floating ifTrue: [
		^ (m parentSandblock
			childClosestTo: (m center ifNil: [m sandblockEditor])
			that: [:b | b ~= m]) ifNil: [m sandblockEditor]].
	
	next := (m isSandblock
		ifTrue: [(m adjacentBlock: 1) ifNil: [m adjacentBlock: -1]]
		ifFalse: [
			aMorph childSandblocks
				ifNotEmpty: [:blocks | (blocks first adjacentBlock: -1) ifNil: [blocks last adjacentBlock: 1]]
				ifEmpty: [(m adjacentBlock: -1) ifNil: [m adjacentBlock: 1]]]) ifNil: [m parentSandblock].
	
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
