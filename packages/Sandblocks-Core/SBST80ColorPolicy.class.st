Class {
	#name : #SBST80ColorPolicy,
	#superclass : #SBColorPolicy,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBST80ColorPolicy >> colorForBlock: aBlock [

	^ (aBlock parentSandblock ifNotNil: #drawnColor ifNil: [Color white]) negated
]
