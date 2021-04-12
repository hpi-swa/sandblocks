Extension { #name : #BlockNode }

{ #category : #'*Sandblocks-Smalltalk' }
BlockNode >> closureCreationNode [

	^ closureCreationNode
]

{ #category : #'*Sandblocks-Smalltalk' }
BlockNode >> closureCreationNode: aNode [

	closureCreationNode := aNode
]

{ #category : #'*Sandblocks-Smalltalk' }
BlockNode >> isEmptyBlock [

	^ self statements size = 1 and: [self statements first isVariableNode and: [self statements first key = 'nil' and: [self startOfLastStatement isNil]]]
]
