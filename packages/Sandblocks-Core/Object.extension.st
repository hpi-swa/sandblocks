Extension { #name : #Object }

{ #category : #'*Sandblocks-Core' }
Object >> asSandblock [

	SBDataProjection allSubclassesDo: [:class | (class matches: self) ifTrue: [^ class new object: self]].
	^ SBExplorer on: self
]

{ #category : #'*Sandblocks-Core' }
Object >> sandblockColor [
	" get a color that may represent this object somewhat uniquely and consistently "
	
	" the identity hashes for classes appear to be rather close together, so we raise them to get larger differences "
	^ Color colorFromPixelValue: (16rFF000000 bitOr: (self identityHash ** 6 \\ 16rffffff max: 1)) depth: 32
]
