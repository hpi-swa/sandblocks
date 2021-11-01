Class {
	#name : #SBJsString,
	#superclass : #SBJsLiteral,
	#category : #'Sandblocks-CustomJavascript'
}

{ #category : #'as yet unclassified' }
SBJsString >> absorbsInput: anEvent [

	^ SBGrammarHandler eventValidForString: anEvent
]

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

{ #category : #'as yet unclassified' }
SBJsString >> writeSourceOn: aStream [

	aStream nextPut: $".
	aStream nextPutAll: self contents.
	aStream nextPut: $"
]
