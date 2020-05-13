Extension { #name : #Object }

{ #category : #'*Sandblocks-Core' }
Object >> asSandblock [

	SBDataProjection allSubclassesDo: [:class | (class matches: self) ifTrue: [^ class new object: self]].
	^ SBExplorer on: self
]

{ #category : #'*Sandblocks-Core' }
Object >> hasRepresentationThat: aSymbol [

	self representationsThat: aSymbol do: [:repr | ^ true].
	^ false
]

{ #category : #'*Sandblocks-Core' }
Object >> representationThat: aSymbol [

	^ self representationThat: aSymbol do: #yourself ifNone: [self error: 'no suitable representation found']
]

{ #category : #'*Sandblocks-Core' }
Object >> representations [

	^ Array streamContents: [:stream |
		self representationsDo: [:class | stream nextPut: class]]
]

{ #category : #'*Sandblocks-Core' }
Object >> representationsDo: aBlock [

	^ SBRepresentation allSubclassesDo: [:class | (class matches: self) ifTrue: [aBlock value: class]]
]

{ #category : #'*Sandblocks-Core' }
Object >> representationsThat: aSymbol [

	^ Array streamContents: [:stream |
		self representationsThat: aSymbol do: [:repr | stream nextPut: repr]]
]

{ #category : #'*Sandblocks-Core' }
Object >> representationsThat: aSymbol do: aBlock [

	aSymbol ifNil: [^ self].
	
	aSymbol isSymbol ifFalse: [^ aSymbol do: [:sym | self representationsThat: sym do: aBlock]].
	
	SBRepresentation allSubclassesDo: [:repr |
		((repr respondsTo: aSymbol) and: [(repr perform: aSymbol) and: [repr matches: self]]) ifTrue: [aBlock value: repr]]
]

{ #category : #'*Sandblocks-Core' }
Object >> sandblockColor [
	" get a color that may represent this object somewhat uniquely and consistently "
	
	" the identity hashes for classes appear to be rather close together, so we raise them to get larger differences "
	^ Color colorFromPixelValue: (16rFF000000 bitOr: (self identityHash ** 6 \\ 16rffffff max: 1)) depth: 32
]
