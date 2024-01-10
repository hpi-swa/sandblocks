Extension { #name : #UndefinedObject }

{ #category : #'*Sandblocks-Core' }
UndefinedObject >> asSandblock [ 

	^ SBUnknown new grammarHandler: SBStGrammarHandler new
]
