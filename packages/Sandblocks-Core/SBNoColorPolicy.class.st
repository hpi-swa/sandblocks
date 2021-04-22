Class {
	#name : #SBNoColorPolicy,
	#superclass : #SBColorMinimalPolicy,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBNoColorPolicy >> colorForBlock: aBlock [

	^ Color white
]
