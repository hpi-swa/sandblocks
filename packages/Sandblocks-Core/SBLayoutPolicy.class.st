Class {
	#name : #SBLayoutPolicy,
	#superclass : #LayoutPolicy,
	#instVars : [
		'minExtentCache'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBLayoutPolicy class >> layoutMorphsOf: aMorph do: aBlock [

	aMorph submorphs do: [:morph |
		(morph disableLayout not and: [morph visible]) ifTrue: [aBlock value: morph]]
]

{ #category : #'as yet unclassified' }
SBLayoutPolicy >> flushLayoutCache [

	minExtentCache := nil
]

{ #category : #'as yet unclassified' }
SBLayoutPolicy >> layout: aMorph in: aRectangle [

	self class layout: aMorph in: aRectangle
]

{ #category : #'as yet unclassified' }
SBLayoutPolicy >> layoutMorphsOf: aMorph do: aBlock [

	aMorph submorphs do: [:morph |
		(morph disableLayout not and: [morph visible]) ifTrue: [aBlock value: morph]]
]

{ #category : #'as yet unclassified' }
SBLayoutPolicy >> minExtentOf: aMorph in: aRectangle [

	minExtentCache ifNotNil: [^ minExtentCache].
	
	^ minExtentCache := self class minExtentOf: aMorph in: aRectangle
]