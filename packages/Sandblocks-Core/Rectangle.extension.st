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

{ #category : #'*Sandblocks-Core' }
Rectangle >> withScalingFactor [

	^ self
]
