Extension { #name : #Color }

{ #category : #'*Sandblocks-Core-converting' }
Color >> asMorph: convert [
	<convert>
	
	^ convert do: [self asMorph]
]

{ #category : #'*Sandblocks-Core' }
Color >> asSandblock [

	^ self shortPrintString parseAsSandblock
]
