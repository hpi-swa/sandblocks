Extension { #name : #UserInputEvent }

{ #category : #'*Sandblocks-Core' }
UserInputEvent >> optionKeyPressed [

	^ buttons anyMask: 32
]
