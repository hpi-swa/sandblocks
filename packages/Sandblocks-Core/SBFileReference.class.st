Class {
	#name : #SBFileReference,
	#superclass : #SBTextBubble,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBFileReference >> drawnColor [

	^ Color white
]

{ #category : #'as yet unclassified' }
SBFileReference >> object [

	^ FileStream readOnlyFileNamed: self contents
]
