Extension { #name : #SBVisualization }

{ #category : #'*Sandblocks-Core-geometry-override' }
SBVisualization >> extent: aPoint [

	super extent: aPoint.
	self targetHeight: aPoint y.
	self scaleY range: (0 to: aPoint y).
	self visualize
]
