Extension { #name : #Fraction }

{ #category : #'*Sandblocks-Core' }
Fraction >> asSandblock [ 

	^ self asString parseAsSandblock 
]
