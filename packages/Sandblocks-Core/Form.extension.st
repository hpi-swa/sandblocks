Extension { #name : #Form }

{ #category : #'*Sandblocks-Core' }
Form >> asMorph: convert [
	<convert>
	
	^ convert do: [self asMorph]
]

{ #category : #'*Sandblocks-Core' }
Form >> asMorphViewer: convert [
	<convert>
	
	^ convert do: [SBFormViewer new replace: self]
]

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
