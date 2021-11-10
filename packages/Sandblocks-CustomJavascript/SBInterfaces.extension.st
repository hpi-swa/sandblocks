Extension { #name : #SBInterfaces }

{ #category : #'*Sandblocks-CustomJavascript' }
SBInterfaces class >> jsExpression [

	^ #(isSandblock isJavascript isExpression)
]

{ #category : #'*Sandblocks-CustomJavascript' }
SBInterfaces class >> jsStatement [

	^ {#isSandblock. #isJavascript. [:b | b isExpression or: [b isStatement]]}
]

{ #category : #'*Sandblocks-CustomJavascript' }
SBInterfaces class >> jsVariable [

	^ #(#isSandblock #isJavascript #isVariable)
]
