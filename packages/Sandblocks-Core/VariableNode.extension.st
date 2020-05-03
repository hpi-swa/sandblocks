Extension { #name : #VariableNode }

{ #category : #'*Sandblocks-Core' }
VariableNode >> asSandblock [

	^ SBName contents: self name
]
