Class {
	#name : #SBStContainer,
	#superclass : #SBStASTNode,
	#instVars : [
		'localBindings',
		'typeCache',
		'receiver'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'artefact protocol' }
SBStContainer >> arguments [

	^ #()
]

{ #category : #'artefact protocol' }
SBStContainer >> artefact [

	^ nil
]

{ #category : #'ast helpers' }
SBStContainer >> binding: aString for: block class: aClass ifPresent: aBlock [

	| outer |
	Symbol
		hasInterned: aString
		ifTrue: [:sym | | binding |
			binding := aClass bindingOf: sym environment: self methodClass environment.
			binding ifNotNil: [^ aBlock value: ((SBStName poolDeclaration: aString) binding: binding)]].
	
	outer := self outerArtefact.
	(outer notNil and: [outer isSmalltalk])
		ifTrue: [^ self outerArtefact binding: aString for: block class: aClass ifPresent: aBlock].
	
	^ nil
]

{ #category : #'method protocol' }
SBStContainer >> body [

	^ self lastSubmorph
]

{ #category : #'artefact protocol' }
SBStContainer >> cacheType: aClass for: aBlock [

	self typeCache at: aBlock put: aClass
]

{ #category : #'artefact protocol' }
SBStContainer >> classVariables [

	^ #()
]

{ #category : #accessing }
SBStContainer >> declarations [

	^ #()
]

{ #category : #'artefact protocol' }
SBStContainer >> ensureExpanded [
]

{ #category : #'compilation cue protocol' }
SBStContainer >> evaluationContext [

	^ nil
]

{ #category : #'compilation cue protocol' }
SBStContainer >> evaluationReceiver [

	^ self receiver
]

{ #category : #'initialize-release' }
SBStContainer >> initialize [

	super initialize.
	
	typeCache := Dictionary new.
	
	self
		layoutPolicy: SBAlgebraLayout new;
		addMorphBack: SBStBlockBody empty;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : #'artefact protocol' }
SBStContainer >> instanceVariables [

	^ #()
]

{ #category : #'artefact protocol' }
SBStContainer >> isArtefact [

	^ true
]

{ #category : #testing }
SBStContainer >> isMethod [

	^ false
]

{ #category : #'artefact protocol' }
SBStContainer >> isMyArgument: aBlock [

	^ false
]

{ #category : #testing }
SBStContainer >> isTopLevel [

	^ true
]

{ #category : #layout }
SBStContainer >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {self body layoutCommands}
]

{ #category : #layout }
SBStContainer >> layoutInset [

	^ self floating ifTrue: [8] ifFalse: [0]
]

{ #category : #'artefact protocol' }
SBStContainer >> methodClass [

	^ receiver ifNotNil: #class ifNil: [UndefinedObject]
]

{ #category : #'ast helpers' }
SBStContainer >> newNullBlock [

	^ nil
]

{ #category : #'method protocol' }
SBStContainer >> object [

	^ receiver
]

{ #category : #'method protocol' }
SBStContainer >> objectInterfaceNear: aBlock at: aSymbol [

	^ SBInterfaces stBlock
]

{ #category : #'compilation cue protocol' }
SBStContainer >> prettySourceString [

	^ self body prettySourceString, ' value'
]

{ #category : #'compilation cue protocol' }
SBStContainer >> receiver [

	^ receiver
]

{ #category : #accessing }
SBStContainer >> receiver: anObject [

	receiver := anObject
]

{ #category : #'artefact protocol' }
SBStContainer >> relatedClass [

	^ self methodClass
]

{ #category : #'compilation cue protocol' }
SBStContainer >> sandblockBlockColorIfAbsent: aBlock [

	^ self preferredColor
]

{ #category : #'artefact protocol' }
SBStContainer >> saveTryFixing: aBoolean quick: aQuickBoolean [

	self allBlocksDo: [:block |
		block valid ifFalse: [
			"block isBinding ifTrue: [self addLocalBindingFor: block]."
			
			aBoolean ifFalse: [^ false] ifTrue: [block tryFixIfFail: [^ false]]]].
	
	^ true
]

{ #category : #'artefact protocol' }
SBStContainer >> setFromSelection: aSelectionBlock [

	self body removeAllMorphs.
	aSelectionBlock childSandblocksDo: [:block |
		self body addMorphBack: block]
]

{ #category : #'artefact protocol' }
SBStContainer >> setFromSource: aString [

	| block |
	self removeMorph: self lastSubmorph.
	block := aString parseAsSandblock.
	block isBlockBody ifFalse: [block := SBStBlockBody empty statements: {block}].
	self addMorphBack: block
]

{ #category : #'compilation cue protocol' }
SBStContainer >> sourceString [

	^ String streamContents: [:s | self writeSourceOn: s]
]

{ #category : #accessing }
SBStContainer >> statements [

	^ self body statements
]

{ #category : #'artefact protocol' }
SBStContainer >> statements: aCollection [

	self body statements: aCollection
]

{ #category : #'artefact protocol' }
SBStContainer >> typeCache [

	^ typeCache
]

{ #category : #'artefact protocol' }
SBStContainer >> typeFor: aBlock [

	^ self typeCache at: aBlock ifAbsent: [nil]
]

{ #category : #'artefact protocol' }
SBStContainer >> veryDeepCopyWith: deepCopier [

	| new previousReceiver |
	previousReceiver := self receiver.
	new := super veryDeepCopyWith: deepCopier.
	new receiver: previousReceiver.
	receiver := previousReceiver.
	^ new
]

{ #category : #'compilation cue protocol' }
SBStContainer >> wantsInteractiveErrorCorrection [

	^ false
]

{ #category : #'compilation cue protocol' }
SBStContainer >> writeSourceOn: aStream [

	aStream nextPut: $[.
	self body writeSourceOn: aStream.
	aStream nextPutAll: '] value'
]
