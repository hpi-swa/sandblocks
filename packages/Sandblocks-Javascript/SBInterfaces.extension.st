Extension { #name : #SBInterfaces }

{ #category : #'*Sandblocks-Javascript' }
SBInterfaces class >> jsExpression [

	^ #(isSandblock isJavascript isExpression)
]

{ #category : #'*Sandblocks-Javascript' }
SBInterfaces class >> jsStatement [

	^ {#isSandblock. #isJavascript. [:b | b isExpression or: [b isStatement]]}
]

{ #category : #'*Sandblocks-Javascript' }
SBInterfaces class >> jsVariable [

	^ #(#isSandblock #isJavascript #isVariable)
]
