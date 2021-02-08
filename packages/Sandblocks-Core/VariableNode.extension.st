Extension { #name : #VariableNode }

{ #category : #'*Sandblocks-Core' }
VariableNode >> asSandblock [

	^ SBStName contents: self name
]
