Class {
	#name : #SBPastePlaceholder,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBPastePlaceholder >> childSandblocksDo: aBlock [
]

{ #category : #'as yet unclassified' }
SBPastePlaceholder >> drawnColor [

	^ Color red
]

{ #category : #'as yet unclassified' }
SBPastePlaceholder >> initialize [

	super initialize.
	
	self extent: self fontToUse height asPoint
]
