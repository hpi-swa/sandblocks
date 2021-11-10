Extension { #name : #SBUnknown }

{ #category : #'*Sandblocks-CustomJavascript' }
SBUnknown >> isJavascript [

	^ self grammarHandler isKindOf: SBJsGrammarHandler
]

{ #category : #'*Sandblocks-CustomJavascript' }
SBUnknown >> isVariable [

	^ true
]

{ #category : #'*Sandblocks-CustomJavascript' }
SBUnknown >> writeJsSourceOn: aStream [

	
]
