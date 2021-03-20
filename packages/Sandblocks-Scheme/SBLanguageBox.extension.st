Extension { #name : #SBLanguageBox }

{ #category : #'*Sandblocks-Scheme' }
SBLanguageBox >> isScheme [

	^ true
]

{ #category : #'*Sandblocks-Scheme' }
SBLanguageBox >> writeScmSourceOn: aStream [

	aStream nextPutAll: '(eval-lang '.
	(SBScmString new contents: self language) writeSourceOn: aStream.
	aStream space.
	(SBScmString new contents: self submorphs second prettySourceString) writeSourceOn: aStream.
	aStream nextPutAll: ')'
]
