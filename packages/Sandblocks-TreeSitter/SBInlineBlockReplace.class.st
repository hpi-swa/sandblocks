Class {
	#name : #SBInlineBlockReplace,
	#superclass : #SBInlineBlock,
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBInlineBlockReplace >> childrenForQueryDo: aBlock [

	
]

{ #category : #'as yet unclassified' }
SBInlineBlockReplace >> initialize [

	super initialize.
	
	self layoutPolicy: TableLayout new
]

{ #category : #'as yet unclassified' }
SBInlineBlockReplace >> layoutCommands [

	^ SBAlgebraCommand morph data: self
]

{ #category : #'as yet unclassified' }
SBInlineBlockReplace >> printTitleOn: aStream [

	aStream nextPutAll: self className
]
