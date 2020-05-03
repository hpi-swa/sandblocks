Class {
	#name : #SB80sColorPolicy,
	#superclass : #SBColorPolicy,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SB80sColorPolicy >> colorForBlock: aBlock [

	aBlock isBlockBody ifTrue: [^ aBlock valueOfProperty: #sandblockBlockColor ifAbsentPut: [Color random]].
	^ (self colorForBlock: (aBlock parentSandblock ifNil: [^ Color white])) negated
]
