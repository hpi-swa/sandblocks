Extension { #name : #Object }

{ #category : #'*Sandblocks-Smalltalk' }
Object >> sbLivePreview [

	SBStRunUntilValue new
		value: self;
		signal
]
