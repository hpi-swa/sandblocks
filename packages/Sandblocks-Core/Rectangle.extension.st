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
Rectangle >> vectorToPoint: aPoint [

	^ ((aPoint - self bottomRight) max: 0@0) - ((self topLeft - aPoint) max: 0@0).
	
]

{ #category : #'*Sandblocks-Core' }
Rectangle >> vectorToRectangle: aRectangle [

	^ ((aRectangle topLeft - self bottomRight) max: 0@0) - ((self topLeft - aRectangle bottomRight) max: 0@0).
	
]

{ #category : #'*Sandblocks-Core' }
Rectangle >> vertical [

	^ self top + self bottom
]
