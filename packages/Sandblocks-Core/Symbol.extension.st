Extension { #name : #Symbol }

{ #category : #'*Sandblocks-Core' }
Symbol >> includesRepresentation: aSymbol [

	^ self = aSymbol
]

{ #category : #'*Sandblocks-Core' }
Symbol >> understood [

	^ [:o | o respondsTo: self]
]
