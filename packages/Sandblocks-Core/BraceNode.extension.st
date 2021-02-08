Extension { #name : #BraceNode }

{ #category : #'*Sandblocks-Core' }
BraceNode >> asSandblock [

	^ SBStArray new type: #dynamic contents: (self elements collect: #asSandblock)
]
