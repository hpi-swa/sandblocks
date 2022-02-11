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
Rectangle >> distanceTo: aPoint [

	| delta |
	"  var dx = Math.max(rect.min.x - p.x, 0, p.x - rect.max.x);
  var dy = Math.max(rect.min.y - p.y, 0, p.y - rect.max.y);
  return Math.sqrt(dx*dx + dy*dy);"
	delta := (origin - aPoint max: 0 @ 0) max: aPoint - corner.
	^ (delta x * delta x + (delta y * delta y)) sqrt
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
