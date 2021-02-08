Class {
	#name : #SBStPlayground,
	#superclass : #SBBlock,
	#instVars : [
		'localBindings',
		'bindings',
		'typeCache',
		'receiver'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStPlayground class >> newFromSource: aString at: aPoint [

	^ (self newFromSource: aString named: 'REPL')
		position: aPoint;
		yourself
]

{ #category : #'as yet unclassified' }
SBStPlayground class >> newFromSource: aString named: anotherString [

	^ self new
		 setFromSource: aString;
		 name: anotherString;
		 yourself
]

{ #category : #'as yet unclassified' }
SBStPlayground class >> newFromSource: aString named: anotherString at: aPoint [

	^ (self newFromSource: aString named: anotherString)
		position: aPoint;
		yourself
]

{ #category : #'artefact protocol' }
SBStPlayground >> artefact [

	^ nil
]

{ #category : #'artefact protocol' }
SBStPlayground >> binding: aString for: block class: aClass ifPresent: aBlock [

	bindings submorphs detect: [:b | b contents = aString] ifFound: [:v | ^ aBlock value: v].
	
	Symbol hasInterned: aString ifTrue: [:sym | | binding |
		binding := aClass bindingOf: sym environment: self methodClass environment.
		binding ifNotNil: [^ aBlock value: ((SBStName poolDeclaration: aString) binding: binding)]].
	
	aString = 'sbEditor' ifTrue: [^ aBlock value: ((SBStName poolDeclaration: aString) binding: #sbEditor -> self sandblockEditor)].
	
	^ nil
]

{ #category : #'compilation cue protocol' }
SBStPlayground >> bindingOf: aString [

	aString = 'sbEditor' ifTrue: [^ #sbEditor -> self sandblockEditor].

	^ (self getOrCreateLocalBinding: aString) binding
]

{ #category : #'artefact protocol' }
SBStPlayground >> bindings [

	^ bindings
]

{ #category : #'artefact protocol' }
SBStPlayground >> bindings: aDictionary [

	bindings := aDictionary
]

{ #category : #'method protocol' }
SBStPlayground >> body [

	^ self lastSubmorph
]

{ #category : #'artefact protocol' }
SBStPlayground >> cacheType: aClass for: aBlock [

	self typeCache at: aBlock put: aClass
]

{ #category : #'as yet unclassified' }
SBStPlayground >> canDeleteChild: aBlock [

	^ aBlock owner = bindings
]

{ #category : #'as yet unclassified' }
SBStPlayground >> childSandblocksDo: aBlock [

	aBlock value: self firstSubmorph firstSubmorph.
	bindings submorphsDo: aBlock.
	aBlock value: self lastSubmorph
]

{ #category : #'artefact protocol' }
SBStPlayground >> containingArtefact [

	^ self
]

{ #category : #'artefact protocol' }
SBStPlayground >> createBinding: aString [

	| decl |
	decl := (SBStName contents: aString)
		binding: aString -> nil;
		yourself.
	bindings addMorphBack: decl.
	self changed.
	^ decl
]

{ #category : #'artefact protocol' }
SBStPlayground >> declarations [

	^ bindings submorphs
]

{ #category : #'artefact protocol' }
SBStPlayground >> ensureExpanded [
]

{ #category : #'compilation cue protocol' }
SBStPlayground >> evaluationContext [

	^ nil
]

{ #category : #'compilation cue protocol' }
SBStPlayground >> evaluationReceiver [

	^ self receiver
]

{ #category : #'as yet unclassified' }
SBStPlayground >> getOrCreateLocalBinding: aString [

	^ bindings submorphs
		detect: [:block | block contents = aString]
		ifNone: [self createBinding: aString]
]

{ #category : #'compilation cue protocol' }
SBStPlayground >> handleDroppedBlock: aBlock event: anEvent adding: aBoolean near: aMorph [

	| object |
	object := aBlock unpackSelection object.
	(self createBinding: object name asLegalSelector) binding value: object
]

{ #category : #'artefact protocol' }
SBStPlayground >> hasUnsavedChanges [

	^ false
]

{ #category : #'artefact protocol' }
SBStPlayground >> hasUnsavedChanges: aBoolean [
]

{ #category : #'as yet unclassified' }
SBStPlayground >> initialize [

	super initialize.
	
	typeCache := Dictionary new.
	
	self
		layoutPolicy: SBAlgebraLayout new;
		layoutInset: 6 withScalingFactor;
		addMorphBack: (SBRow new
			cellGap: 8 withScalingFactor;
			addMorphBack: (SBTextBubble new layoutInset: 4 withScalingFactor; contents: 'Workspace');
			addMorphBack: (bindings := SBRow new cellGap: 4 withScalingFactor));
		addMorphBack: SBStBlockBody empty;
		vResizing: #shrinkWrap;
		hResizing: #rigid;
		attachDecorator: SBMoveDecorator new;
		attachDecorator: SBResizableDecorator new
]

{ #category : #'artefact protocol' }
SBStPlayground >> isArtefact [

	^ true
]

{ #category : #'artefact protocol' }
SBStPlayground >> isRepl [

	^ true
]

{ #category : #testing }
SBStPlayground >> isTopLevel [

	^ true
]

{ #category : #'as yet unclassified' }
SBStPlayground >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {
			SBAlgebraCommand morph data: self firstSubmorph.
			SBAlgebraCommand hardLine withGap: true.
			self lastSubmorph layoutCommands}
]

{ #category : #'as yet unclassified' }
SBStPlayground >> localVariables [

	^ bindings
]

{ #category : #'artefact protocol' }
SBStPlayground >> methodClass [

	^ receiver ifNotNil: #class ifNil: [UndefinedObject]
]

{ #category : #'artefact protocol' }
SBStPlayground >> name [

	^ self firstSubmorph firstSubmorph contents
]

{ #category : #'artefact protocol' }
SBStPlayground >> name: aString [

	self firstSubmorph firstSubmorph contents: aString
]

{ #category : #'method protocol' }
SBStPlayground >> object [

	^ receiver
]

{ #category : #'compilation cue protocol' }
SBStPlayground >> objectInterfaceAt: aNumber adding: aBoolean [

	^ SBInterfaces always
]

{ #category : #'artefact protocol' }
SBStPlayground >> printOn: aStream [

	aStream nextPutAll: 'workspace '.
	aStream nextPutAll: (self name truncateWithElipsisTo: 20)
]

{ #category : #'compilation cue protocol' }
SBStPlayground >> receiver [

	^ receiver
]

{ #category : #'compilation cue protocol' }
SBStPlayground >> receiver: anObject [

	anObject ifNotNil: [self name: (anObject asString truncateWithElipsisTo: 20)].
	receiver := anObject
]

{ #category : #'artefact protocol' }
SBStPlayground >> relatedClass [

	^ self methodClass
]

{ #category : #'artefact protocol' }
SBStPlayground >> saveTryFixing: aBoolean quick: aQuickBoolean [

	self allBlocksDo: [:block |
		block valid ifFalse: [
			"block isBinding ifTrue: [self addLocalBindingFor: block]."
			
			aBoolean ifFalse: [^ false] ifTrue: [block tryFixIfFail: [^ false]]]].
	
	^ true
]

{ #category : #'artefact protocol' }
SBStPlayground >> setFromSelection: aSelectionBlock [

	self body removeAllMorphs.
	aSelectionBlock childSandblocksDo: [:block |
		self body addMorphBack: block]
]

{ #category : #'artefact protocol' }
SBStPlayground >> setFromSource: aString [

	self removeMorph: self lastSubmorph.
	self addMorphBack: aString parseAsSandblock
]

{ #category : #'compilation cue protocol' }
SBStPlayground >> sourceString [

	^ String streamContents: [:s | self writeSourceOn: s]
]

{ #category : #'artefact protocol' }
SBStPlayground >> statements: aCollection [

	self body statements: aCollection
]

{ #category : #'as yet unclassified' }
SBStPlayground >> storeOn: aStream [

	SBExample self: [SBStPlayground newFromSource: '5 + 5 squared' named: 'REPL'] args: [{'' writeStream}] label: 'simple'.
	aStream nextPut: $(.
	aStream nextPutAll: self className.
	aStream nextPutAll: ' newFromSource: '.
	self body prettySourceString storeOn: aStream.
	aStream nextPutAll: ' named: '.
	self name storeOn: aStream.
	aStream nextPutAll: ' at: '.
	self position storeOn: aStream.
	aStream nextPut: $)
]

{ #category : #'artefact protocol' }
SBStPlayground >> textContents [

	^ self name
]

{ #category : #'artefact protocol' }
SBStPlayground >> typeCache [

	^ typeCache
]

{ #category : #'artefact protocol' }
SBStPlayground >> typeFor: aBlock [

	^ self typeCache at: aBlock ifAbsent: [nil]
]

{ #category : #'artefact protocol' }
SBStPlayground >> veryDeepCopyWith: deepCopier [

	| new previousReceiver |
	previousReceiver := self receiver.
	new := super veryDeepCopyWith: deepCopier.
	new receiver: previousReceiver.
	receiver := previousReceiver.
	^ new
]

{ #category : #'compilation cue protocol' }
SBStPlayground >> wantsInteractiveErrorCorrection [

	^ false
]

{ #category : #'compilation cue protocol' }
SBStPlayground >> writeSourceOn: aStream [

	self body writeSourceOn: aStream.
	aStream nextPutAll: ' value'
]
