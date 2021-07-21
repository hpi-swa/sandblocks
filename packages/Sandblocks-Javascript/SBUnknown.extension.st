Extension { #name : #SBUnknown }

{ #category : #'*Sandblocks-Javascript' }
SBUnknown >> isJavascript [

	^ self grammarHandler isKindOf: SBJsGrammarHandler
]

{ #category : #'*Sandblocks-Javascript' }
SBUnknown >> isVariable [

	^ true
]

{ #category : #'*Sandblocks-Javascript' }
SBUnknown >> writeJsSourceOn: aStream [

	
]
