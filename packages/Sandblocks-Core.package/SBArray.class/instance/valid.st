converting
valid

	type = #literal ifFalse: [^ true].
	
	self childSandblocksDo: [:b | b isLiteralBlock ifFalse: [^ false]].
	^ true