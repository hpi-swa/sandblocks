Extension { #name : #SBInlineBlockChoice }

{ #category : #'*Sandblocks-JavascriptReact' }
SBInlineBlockChoice >> compatibleWithType: aString [

	^ self alternatives anySatisfy: [:alt | alt type = aString]
]
