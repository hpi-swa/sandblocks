Extension { #name : #SBUnknown }

{ #category : #'*Sandblocks-Ohm' }
SBUnknown >> isOhm [

	^ self grammarHandler isKindOf: SBScmGrammarHandler
]
