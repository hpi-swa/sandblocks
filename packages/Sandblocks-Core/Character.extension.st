Extension { #name : #Character }

{ #category : #'*Sandblocks-Core' }
Character >> asSandblockShortcut [

	^ SBShortcut new character: self
]

{ #category : #'*Sandblocks-Core' }
Character >> command [

	^ self asSandblockShortcut withCommand
]

{ #category : #'*Sandblocks-Core' }
Character >> ctrl [

	^ self asSandblockShortcut withCtrl
]

{ #category : #'*Sandblocks-Core' }
Character >> shift [

	^ self asSandblockShortcut withShift
]
