Class {
	#name : #SBDeleteCommand,
	#superclass : #SBCommand,
	#instVars : [
		'target',
		'oldOwner',
		'oldIndex',
		'oldConnections'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBDeleteCommand >> do [

	| nextSelection |
	nextSelection := target containingSandblock focusAfterDeleteIfNone: [self nextBlockFrom: target].
	oldOwner := target owner.
	self removeConnectionsFor: target.
	oldIndex := oldOwner submorphIndexOf: target.
	oldOwner removeMorph: target.
	
	^ nextSelection isInEditor ifTrue: [nextSelection] ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBDeleteCommand >> nextBlockFrom: aMorph [

	| next m |
	m := aMorph isSandblock ifTrue: [aMorph] ifFalse: [aMorph firstBlock ifNil: [aMorph containingSandblock]].
	m parentSandblock ifNil: [^ m sandblockEditor].
	
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
	
	^ (next isNil or: [next containingFloat ~= m containingFloat])
		ifTrue: [m sandblockEditor]
		ifFalse: [next]
]

{ #category : #'as yet unclassified' }
SBDeleteCommand >> removeConnectionsFor: aBlock [

	oldConnections := Array streamContents: [:stream |
		aBlock isSandblock ifTrue: [aBlock allConnectionsDo: [:m |
			stream nextPut: m]]].
	oldConnections do: [:m | m delete]
]

{ #category : #'as yet unclassified' }
SBDeleteCommand >> restoreConnectionsFor: aBlock in: aContainer [

	oldConnections do: [:connection | aContainer addMorphBack: connection]
]

{ #category : #'as yet unclassified' }
SBDeleteCommand >> setArtefactFrom [

	^ target
]

{ #category : #'as yet unclassified' }
SBDeleteCommand >> target [

	^ target
]

{ #category : #'as yet unclassified' }
SBDeleteCommand >> target: aMorph [

	target := aMorph
]

{ #category : #'as yet unclassified' }
SBDeleteCommand >> undo [

	oldOwner addMorph: target asElementNumber: oldIndex.
	self restoreConnectionsFor: target in: oldOwner.
	^ target containingSandblock
]

{ #category : #'as yet unclassified' }
SBDeleteCommand >> vrDo [

	| vrNode |
	vrNode := target sandblockEditor treeRegistry treeFor: target.
	vrNode getParent removeChild: vrNode
]

{ #category : #'as yet unclassified' }
SBDeleteCommand >> vrUndo [

	| vrNode |
	vrNode := target sandblockEditor treeRegistry treeFor: oldOwner.
	vrNode getParent addChild: vrNode afterIndex: oldIndex.
	vrNode relayout
]
