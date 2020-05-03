Extension { #name : #BraceNode }

{ #category : #'*Sandblocks-Core' }
BraceNode >> asSandblock [

	^ SBArray new type: #dynamic contents: (self elements collect: #asSandblock)
]
