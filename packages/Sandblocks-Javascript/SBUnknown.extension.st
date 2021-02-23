Extension { #name : #SBUnknown }

{ #category : #'*Sandblocks-Javascript' }
SBUnknown >> isJavascript [

	^ self grammarHandler isKindOf: SBJsGrammarHandler
]
