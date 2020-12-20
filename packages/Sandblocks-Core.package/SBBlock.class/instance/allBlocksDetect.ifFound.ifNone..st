hierarchy
allBlocksDetect: aBlock ifFound: aSuccessBlock ifNone: aFailureBlock

	self allBlocksDo: [:b | (aBlock value: b) ifTrue: [^ aSuccessBlock value: b]].
	^ aFailureBlock value