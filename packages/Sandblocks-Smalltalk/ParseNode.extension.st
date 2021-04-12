Extension { #name : #ParseNode }

{ #category : #'*Sandblocks-Smalltalk' }
ParseNode >> asSandblock [

	^ self accept: SBStMethodToBlockWithSubs new
]
