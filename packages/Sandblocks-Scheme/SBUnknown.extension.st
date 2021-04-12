Extension { #name : #SBUnknown }

{ #category : #'*Sandblocks-Scheme' }
SBUnknown >> isScheme [

	^ self grammarHandler isKindOf: SBScmGrammarHandler
]

{ #category : #'*Sandblocks-Scheme' }
SBUnknown >> writeScmSourceOn: aStream [

	
]
