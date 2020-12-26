Class {
	#name : #SBJsString,
	#superclass : #SBJsLiteral,
	#category : #'Sandblocks-Javascript'
}

{ #category : #'as yet unclassified' }
SBJsString >> centerAlignSymbols [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsString >> symbols [

	^ #('"' '"')
]

{ #category : #'as yet unclassified' }
SBJsString >> textMorphClass [

	^ SBMultilineOwnTextMorph
]
