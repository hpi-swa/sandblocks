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
Character >> isLikelyUnmodifiedOnKeyboard [

	^ self asInteger >= 32 and: [self asInteger < 255 and: [self asInteger ~= 127]]
]

{ #category : #'*Sandblocks-Core' }
Character >> isPrintable [

	^ self asInteger >= 16r20 or: [{Character cr. Character tab. Character space. Character linefeed} includes: self]
]

{ #category : #'*Sandblocks-Core' }
Character >> option [

	^ self asSandblockShortcut withOption
]

{ #category : #'*Sandblocks-Core' }
Character >> shift [

	^ self asSandblockShortcut withShift
]
