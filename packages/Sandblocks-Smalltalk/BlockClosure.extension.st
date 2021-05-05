Extension { #name : #BlockClosure }

{ #category : #'*Sandblocks-Smalltalk' }
BlockClosure >> sbStBuild [

	^ self value: SBStBuilder new
]

{ #category : #'*Sandblocks-Smalltalk' }
BlockClosure >> sbStSave [

	| block |
	block := self sbStBuild.
	(block saveTryFixing: false quick: false) ifFalse: [^ self error: 'failed to save block'].
	^ block
]
