Class {
	#name : #SBExampleCluster,
	#superclass : #SBCluster,
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'as yet unclassified' }
SBExampleCluster >> watchesAsMatrix: aCollectionOfSBExampleWatches [

	"Determine how watches are dissected to create a grid"
	^ self subclassResponsibility. 
]
