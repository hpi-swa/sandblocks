Extension { #name : #Rectangle }

{ #category : #'*Sandblocks-Core' }
Rectangle >> asEdgeInsets [

	^ SBEdgeInsets
		left: self left
		right: self right
		top: self top
		bottom: self bottom
]

{ #category : #'*Sandblocks-Core' }
Rectangle >> distanceTo: aRectangle [

	| x y |

	x := ((self left - aRectangle right) max: (aRectangle left - self right)) max: 0.
	y := ((self top - aRectangle bottom) max: (aRectangle top - self bottom)) max: 0.
	^ (x @ y) r
	
]

{ #category : #'*Sandblocks-Core' }
Rectangle >> horizontal [

	^ self left + self right
]

{ #category : #'*Sandblocks-Core' }
Rectangle >> line: aSideSymbol do: aBlock [

	aSideSymbol = #left ifTrue: [^ aBlock value: self topLeft value: self bottomLeft].
	aSideSymbol = #right ifTrue: [^ aBlock value: self topRight value: self bottomRight].
	aSideSymbol = #top ifTrue: [^ aBlock value: self topLeft value: self topRight].
	aSideSymbol = #bottom ifTrue: [^ aBlock value: self bottomLeft value: self bottomRight].
	self error: 'invalid edge'
]

{ #category : #'*Sandblocks-Core' }
Rectangle >> vertical [

	^ self top + self bottom
]
