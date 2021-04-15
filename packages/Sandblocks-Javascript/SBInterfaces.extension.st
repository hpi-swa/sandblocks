Extension { #name : #SBInterfaces }

{ #category : #'*Sandblocks-Javascript' }
SBInterfaces class >> jsExpression [

	^ #(isSandblock isJavascript isExpression)
]

{ #category : #'*Sandblocks-Javascript' }
SBInterfaces class >> jsVariable [

	^ #(#isSandblock #isJavascript #isVariable)
]
