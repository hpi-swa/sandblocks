Class {
	#name : #SBOhmTerminal,
	#superclass : #SBOhmASTNode,
	#category : #'Sandblocks-Ohm'
}

{ #category : #'as yet unclassified' }
SBOhmTerminal >> contents: aString [

	self currentTextMorph contents: aString
]

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
SBOhmTerminal >> symbols [

	^ #('"' '"')
]
