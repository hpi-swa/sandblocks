Extension { #name : #SBUnknown }

{ #category : #'*Sandblocks-Scheme' }
SBUnknown >> isScheme [

	^ self grammarHandler isKindOf: SBScmGrammarHandler
]
