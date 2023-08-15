Extension { #name : #SBExampleValueDisplay }

{ #category : #'*Sandblocks-Core' }
SBExampleValueDisplay >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self submorphs collect: #layoutCommands separatedBy: [SBAlgebraCommand gap])
]
