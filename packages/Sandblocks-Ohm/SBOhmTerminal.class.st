Class {
	#name : #SBOhmTerminal,
	#superclass : #SBOhmASTNode,
	#category : #'Sandblocks-Ohm'
}

{ #category : #'as yet unclassified' }
SBOhmTerminal >> currentTextMorph [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBOhmTerminal >> initialize [

	super initialize.
	
	self
		addMorphBack: SBOwnTextMorph new;
		changeTableLayout
]

{ #category : #'as yet unclassified' }
SBOhmTerminal >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBOhmTerminal >> isTerminal [

	^ true
]

{ #category : #'as yet unclassified' }
SBOhmTerminal >> symbols [

	^ #('"' '"')
]

{ #category : #'as yet unclassified' }
SBOhmTerminal >> writeSourceOn: aStream [

	aStream nextPut: $".
	aStream nextPutAll: self contents.
	aStream nextPut: $"
]
