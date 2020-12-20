Extension { #name : #SBRatPackRoute }

{ #category : #'*Sandblocks-Core' }
SBRatPackRoute >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {
			"SBAlgebraCommand morph data: "self firstSubmorph layoutCommands.
			SBAlgebraCommand hardLine withGap: true.
			self body layoutCommands.
			SBAlgebraCommand hardLine withGap: true.
			self lastSubmorph layoutCommands.
		}
]
