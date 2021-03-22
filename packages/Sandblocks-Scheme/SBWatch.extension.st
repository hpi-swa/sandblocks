Extension { #name : #SBWatch }

{ #category : #'*Sandblocks-Scheme' }
SBWatch >> asScmExpression: converter [
	<convert>

	converter if: [self expression isScheme] do: [
		SBScmExpression new addAllMorphs: {
			SBScmIdentifier new contents: 'SBWatch'.
			SBScmSymbol new contents: 'report:for:'.
			self expression veryDeepCopy.
			SBScmNumber new contents: self identifier asString}]
]

{ #category : #'*Sandblocks-Scheme' }
SBWatch >> isScheme [

	^ true
]

{ #category : #'*Sandblocks-Scheme' }
SBWatch >> writeScmSourceOn: aStream [

	aStream nextPutAll: '(perform SBWatch ''report:for: '.
	self expression writeSourceOn: aStream.
	aStream space.
	aStream nextPutAll: self identifier asString.
	aStream nextPutAll: ')'
]
