Extension { #name : #Object }

{ #category : #'*Sandblocks-Core' }
Object >> anyRepresentationThat: aSymbol [

	^ self newFirstSafeOptionFrom: (self representationsThat: aSymbol)
]

{ #category : #'*Sandblocks-Core' }
Object >> asSandblock [

	SBDataProjection allSubclassesDo: [:class | (class matches: self) ifTrue: [^ class new object: self]].
	^ SBExplorer on: self
]

{ #category : #'*Sandblocks-Core' }
Object >> firstSafeOptionFrom: aCollection [
	" try to find the first representation that causes no side effects. If none were found assume, that the side effect was the user's intention "

	^ aCollection detect: [:repr | repr causesSideEffects not] ifNone: [aCollection first]
]

{ #category : #'*Sandblocks-Core' }
Object >> hasDerivableRepresentationThat: aSymbol [

	self representationsThat: aSymbol do: [:repr | repr isLeaf ifFalse: [^ true]] deep: false.
	^ false
]

{ #category : #'*Sandblocks-Core' }
Object >> hasRepresentationThat: aSymbol [

	self representationsThat: aSymbol do: [:repr | ^ true] deep: false.
	^ false
]

{ #category : #'*Sandblocks-Core' }
Object >> isSandblock [

	^ false
]

{ #category : #'*Sandblocks-Core' }
Object >> newFirstSafeOptionFrom: aCollection [

	^ (self firstSafeOptionFrom: aCollection) newFor: self
]

{ #category : #'*Sandblocks-Core' }
Object >> representIn: aMorph as: aSymbol near: aPointOrMorph [

	| options representation |
	options := self representationsThat: aSymbol.
	options ifEmpty: [^ self].
	representation := self newFirstSafeOptionFrom: options.
	options size > 1 ifTrue: [ | prompt |
		prompt := SBRepresentationPrompt new options: options target: self current: representation.
		aMorph openMorphInView: prompt.
		prompt position: (aPointOrMorph isPoint ifTrue: [aPointOrMorph] ifFalse: [aPointOrMorph position]).
		aMorph openMorphInView: representation].
	^ representation
]

{ #category : #'*Sandblocks-Core' }
Object >> representationCapabilities [

	| set |
	SBExample self: [Morph new] args: [{}] label: 'simple'.
	set := Set new.
	self representationsDo: [:repr |
		set addAll: (repr class methodDictionary values collect: #selector)].
	set
		remove: #matches: ifAbsent: [nil];
		remove: #newFor: ifAbsent: [nil].
	^ set
]

{ #category : #'*Sandblocks-Core' }
Object >> representationThat: aSymbol [

	^ self representationThat: aSymbol do: #yourself ifNone: [self error: 'no suitable representation found']
]

{ #category : #'*Sandblocks-Core' }
Object >> representationThat: aSymbol do: aBlock ifNone: anotherBlock [

	| options index representation |
	options := self representationsThat: aSymbol.
	options size = 1 ifTrue: [^ aBlock value: (options first newFor: self)].
	options ifEmpty: [^ anotherBlock value].
	index := UIManager default
		chooseFrom: (options collect: [:repr | repr prettyName])
		title: ('How to represent {1} ({2})' format: {self asString. self className}).
	index = 0 ifTrue: [^ anotherBlock value].
	representation := (options at: index) newFor: self.
	^ aBlock value: representation
]

{ #category : #'*Sandblocks-Core' }
Object >> representations [

	^ Array streamContents: [:stream |
		self representationsDo: [:class | stream nextPut: class]]
]

{ #category : #'*Sandblocks-Core' }
Object >> representationsDo: aBlock [

	^ SBRepresentation representationsDo: [:class | (class matches: self) ifTrue: [aBlock value: class]]
]

{ #category : #'*Sandblocks-Core' }
Object >> representationsThat: aSymbol [

	^ (Array streamContents: [:stream |
		self representationsThat: aSymbol do: [:repr | stream nextPut: repr]]) sort: #priority asSortFunction reversed.
]

{ #category : #'*Sandblocks-Core' }
Object >> representationsThat: aSymbol do: aBlock [

	self representationsThat: aSymbol do: aBlock deep: 0
]

{ #category : #'*Sandblocks-Core' }
Object >> representationsThat: aSymbol do: aBlock deep: aBoolean [

	SBExample self: ['5+5' parseAsSandblock] args: [{#isToplevelMorph. [:repr | nil]. true}] label: 'simple'.
	aSymbol ifNil: [^ self].
	aSymbol isSymbol ifFalse: [
		^ aSymbol do: [:sym | self representationsThat: sym do: aBlock]].
	SBRepresentation representationsDo: [:repr |
		((repr supports: aSymbol) and: [repr matches: self]) ifTrue: [aBlock value: repr].
		
		((aBoolean isBoolean not and: [aBoolean < 2]) and: [
			repr identity not and: [repr isLeaf not and: [repr matches: self]]]) ifTrue: [ | nested |
			(nested := repr eagerNewFor: self) ~= self ifTrue: [
				nested
					representationsThat: aSymbol
					do: [:nestedRepr |
						aBlock value: (SBDerivedRepresentation from: repr to: nestedRepr)]
					deep: aBoolean + 1]]]
]

{ #category : #'*Sandblocks-Core' }
Object >> safeRepresentationThat: aSymbol do: aBlock ifNone: anotherBlock [

	| options |
	options := self representationsThat: aSymbol.
	options size = 1 ifTrue: [^ aBlock value: (options first newFor: self)].
	options ifEmpty: [^ anotherBlock value].
	^ aBlock value: (self newFirstSafeOptionFrom: options)
]
