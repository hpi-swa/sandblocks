Extension { #name : #SBTextColorPolicy }

{ #category : #'*Sandblocks-Smalltalk' }
SBTextColorPolicy >> emphasisForMessagePart: aBlock [

	(aBlock isMessagePart and: [aBlock messageSend isMethod]) ifTrue: [^ TextEmphasis bold].
	^ TextEmphasis normal
]
