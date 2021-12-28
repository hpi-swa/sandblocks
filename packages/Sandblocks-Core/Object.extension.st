Extension { #name : #Object }

{ #category : #'*Sandblocks-Core-converting' }
Object >> allConversionsFor: anInterfaceCollection do: aBlock [

	^ self allConversionsFor: anInterfaceCollection do: aBlock depth: 0 pathName: ''
]

{ #category : #'*Sandblocks-Core-converting' }
Object >> allConversionsFor: anInterfaceCollection do: aBlock depth: aNumber pathName: aString [

	| convert current |
	current := nil.
	convert := SBConvert new
		objectInterface: anInterfaceCollection;
		success: [:object | | path |
			path := aString, (aString ifEmpty: [''] ifNotEmpty: [' -> ']), current name.
			(object satisfies: anInterfaceCollection) ifTrue: [aBlock value: {path. object}].
			aNumber > 0 ifTrue: [
				object
					allConversionsFor: anInterfaceCollection
					do: aBlock
					depth: aNumber - 1
					pathName: path]].
	
	self converterOptionsDo: [:option |
		current := option.
		option apply: convert]
]

{ #category : #'*Sandblocks-Core' }
Object >> anyRepresentationThat: aSymbol [

	| options |
	options := self representationsThat: aSymbol.
	options ifEmpty: [^ nil].
	^ self newFirstSafeOptionFrom: options
]

{ #category : #'*Sandblocks-Core' }
Object >> asSandblock [

	SBDataProjection allSubclassesDo: [:class | (class matches: self) ifTrue: [^ class new object: self]].
	^ SBExplorer on: self
]

{ #category : #'*Sandblocks-Core-converting' }
Object >> bindToPlayground: convert [
	<convert>
	<convertPriority: -3>

	convert do: [
		SBStPlayground new
			receiver: self;
			statements: {SBStName contents: 'self'}]
]

{ #category : #'*Sandblocks-Core-converting' }
Object >> convertedFor: anInterfaceCollection do: aBlock [

	| convert |
	(self satisfies: anInterfaceCollection) ifTrue: [^ aBlock value: self].
	(self object satisfies: anInterfaceCollection) ifTrue: [^ aBlock value: self object].
	
	convert := SBConvert new
		objectInterface: anInterfaceCollection;
		success: [:object | (object satisfies: anInterfaceCollection) ifTrue: [^ aBlock value: object]].
	
	self object converterOptionsDo: [:option | option apply: convert].
	
	^ nil
]

{ #category : #'*Sandblocks-Core-converting' }
Object >> convertedFor: anInterfaceCollection doWithChooser: aBlock [

	| convert |
	(self satisfies: anInterfaceCollection) ifTrue: [^ aBlock value: self].
	(self object satisfies: anInterfaceCollection) ifTrue: [^ aBlock value: self object].
	
	convert := SBConvert new
		objectInterface: anInterfaceCollection;
		success: [:object |
			(object satisfies: anInterfaceCollection) ifTrue: [ | converted |
				converted := aBlock value: object.
				self assert: converted isSandblock.
				self assert: converted sandblockEditor notNil.
				SBDropChooser new
					openFor: converted
					interface: anInterfaceCollection
					original: self
					do: aBlock.
				^ converted]].
	
	self object converterOptionsDo: [:option | option apply: convert].
	
	^ nil
]

{ #category : #'*Sandblocks-Core-converting' }
Object >> converterOptionsDo: aBlock [

	((Pragma allNamed: #convert from: self class to: Object) sorted: [:pragmaA :pragmaB |
		((pragmaA method pragmaAt: #convertPriority:) ifNotNil: [:p | p arguments first] ifNil: [0]) > ((pragmaB method pragmaAt: #convertPriority:) ifNotNil: [:p | p arguments first] ifNil: [0])]) do: [:pragma | aBlock value: (SBConvertOption on: self send: pragma selector)]
]

{ #category : #'*Sandblocks-Core' }
Object >> example: aSelfClosure args: anArgumentsClosure label: aString [
	"marker"

	
]

{ #category : #'*Sandblocks-Core' }
Object >> example: aSelfClosure args: anArgumentsClosure label: aString assert: anAssertClosure [
	"marker"

	
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

	self representationsThat: aSymbol do: [:repr | ^ true] deep: 0.
	^ false
]

{ #category : #'*Sandblocks-Core' }
Object >> isConnector [

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
Object >> object [

	^ self
]

{ #category : #'*Sandblocks-Core-converting' }
Object >> openClass: converter [
	<convert>
	<convertPriority: -2>

	converter do: [SBStClassMethodEditor new class: self class]
]

{ #category : #'*Sandblocks-Core-converting' }
Object >> openExplorer: convert [
	<convert>
	<convertPriority: -1>

	convert do: [SBExplorer on: self]
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
		
		((aBoolean isBoolean not and: [aBoolean < 3]) and: [
			repr identity not and: [repr isLeaf not and: [repr matches: self]]]) ifTrue: [ | nested |
			(nested := repr eagerNewFor: self) ~= self ifTrue: [
				nested
					representationsThat: aSymbol
					do: [:nestedRepr |
						aBlock value: (SBDerivedRepresentation from: repr to: nestedRepr)]
					deep: aBoolean + 1]]] for: self
]

{ #category : #'*Sandblocks-Core' }
Object >> sandblockColor [

	^ Color colorFromPixelValue: (4278190080 bitOr: ((self identityHash ** 3) \\ 16777215 max: 1)) depth: 32
]

{ #category : #'*Sandblocks-Core' }
Object >> sandblocksHalt [

	| process parent processCopy uiBlock |
	process := Processor activeProcess.
	
	Project current spawnNewProcessIfThisIsUI: process.
	
	processCopy := (Process forContext: thisContext copyStack priority: process priority)
		shouldResumeFromDebugger: false;
		yourself.
	
	uiBlock := [SBEditor current reportError: Halt new process: processCopy source: nil].
	
	(Project current uiProcess isActiveProcess not or: [process isActiveProcess])
		ifTrue: [Project current addDeferredUIMessage: uiBlock]
		ifFalse: uiBlock.
	
	parent := thisContext sender.
	[
		processCopy
			popTo: processCopy suspendedContext sender;
			step] fork.
	process suspend
]

{ #category : #'*Sandblocks-Core' }
Object >> satisfies: aCollection [

	^ aCollection allSatisfy: [:obj | obj value: self]
]
