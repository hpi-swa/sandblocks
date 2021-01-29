Extension { #name : #Form }

{ #category : #'*Sandblocks-Core' }
Form >> fillColor: aColor [

	self getCanvas fillColor: aColor
]

{ #category : #'*Sandblocks-Core' }
Form >> scaledToFit: aPoint [

	| factor |
	factor := aPoint / self extent.
	factor := factor x min: factor y.
	
	^ self scaledToSize: self extent * factor
]
