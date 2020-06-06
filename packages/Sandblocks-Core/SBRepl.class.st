Class {
	#name : #SBRepl,
	#superclass : #SBBlock,
	#instVars : [
		'localBindings',
		'bindings',
		'typeCache',
		'receiver'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBRepl class >> newFromSource: aString at: aPoint [

	^ (self newFromSource: aString named: 'REPL')
		position: aPoint;
		yourself
]

{ #category : #'as yet unclassified' }
SBRepl class >> newFromSource: aString named: anotherString [

	^ self new
		 setFromSource: aString;
		 name: anotherString;
		 yourself
]

{ #category : #'as yet unclassified' }
SBRepl class >> newFromSource: aString named: anotherString at: aPoint [

	^ (self newFromSource: aString named: anotherString)
		position: aPoint;
		yourself
]

{ #category : #'artefact protocol' }
SBRepl >> artefact [

	^ nil
]

{ #category : #'artefact protocol' }
SBRepl >> bindingFor: aString class: aClass ifPresent: aBlock [

	bindings submorphs detect: [:b | b contents = aString] ifFound: [:v | ^ aBlock value: v].
	
	Symbol hasInterned: aString ifTrue: [:sym | | binding |
		binding := aClass bindingOf: sym environment: self methodClass environment.
		binding ifNotNil: [^ aBlock value: ((SBName poolDeclaration: aString) binding: binding)]].
	
	^ nil
]

{ #category : #'compilation cue protocol' }
SBRepl >> bindingOf: aString [

	^ (self getOrCreateLocalBinding: aString) binding
]

{ #category : #'artefact protocol' }
SBRepl >> bindings [

	^ bindings
]

{ #category : #'artefact protocol' }
SBRepl >> bindings: aDictionary [

	bindings := aDictionary
]

{ #category : #'method protocol' }
SBRepl >> body [

	^ self lastSubmorph
]

{ #category : #'artefact protocol' }
SBRepl >> cacheType: aClass for: aBlock [

	self typeCache at: aBlock put: aClass
]

{ #category : #'as yet unclassified' }
SBRepl >> canDeleteChild: aBlock [

	^ aBlock owner = bindings
]

{ #category : #'as yet unclassified' }
SBRepl >> childSandblocksDo: aBlock [

	aBlock value: self firstSubmorph firstSubmorph.
	bindings submorphsDo: aBlock.
	aBlock value: self lastSubmorph
]

{ #category : #'artefact protocol' }
SBRepl >> containingArtefact [

	^ self
]

{ #category : #'artefact protocol' }
SBRepl >> contextAcceptedRepresentationAt: aNumber [

	^ #isObject
]

{ #category : #'artefact protocol' }
SBRepl >> createBinding: aString [

	| decl |
	decl := (SBName contents: aString)
		binding: aString -> nil;
		yourself.
	bindings addMorphBack: decl.
	self changed.
	^ decl
]

{ #category : #'artefact protocol' }
SBRepl >> declarations [

	^ bindings submorphs
]

{ #category : #'artefact protocol' }
SBRepl >> ensureExpanded [
]

{ #category : #'compilation cue protocol' }
SBRepl >> evaluationContext [

	^ nil
]

{ #category : #'compilation cue protocol' }
SBRepl >> evaluationReceiver [

	^ self receiver
]

{ #category : #'as yet unclassified' }
SBRepl >> getOrCreateLocalBinding: aString [

	^ bindings submorphs
		detect: [:block | block contents = aString]
		ifNone: [self createBinding: aString]
]

{ #category : #'compilation cue protocol' }
SBRepl >> handleDroppedBlock: aBlock event: anEvent [

	aBlock object
		representationThat: #isObject
		do: [:repr |
			(self createBinding: repr name asLegalSelector) binding value: repr]
		ifNone: [nil]
]

{ #category : #'artefact protocol' }
SBRepl >> hasUnsavedChanges [

	^ false
]

{ #category : #'artefact protocol' }
SBRepl >> hasUnsavedChanges: aBoolean [
]

{ #category : #'as yet unclassified' }
SBRepl >> initialize [

	super initialize.
	
	typeCache := Dictionary new.
	
	self
		layoutInset: 6 withScalingFactor;
		addMorphBack: (SBRow new
			cellGap: 8 withScalingFactor;
			addMorphBack: (SBTextBubble new layoutInset: 4 withScalingFactor; contents: 'Workspace');
			addMorphBack: (bindings := SBRow new cellGap: 4 withScalingFactor));
		addMorphBack: SBBlockBody empty;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		changeTableLayout;
		attachDecorator: SBMoveDecorator new
]

{ #category : #'artefact protocol' }
SBRepl >> isArtefact [

	^ true
]

{ #category : #'artefact protocol' }
SBRepl >> isRepl [

	^ true
]

{ #category : #'as yet unclassified' }
SBRepl >> localVariables [

	^ bindings
]

{ #category : #'artefact protocol' }
SBRepl >> methodClass [

	^ UndefinedObject
]

{ #category : #'artefact protocol' }
SBRepl >> name [

	^ self firstSubmorph firstSubmorph contents
]

{ #category : #'artefact protocol' }
SBRepl >> name: aString [

	self firstSubmorph firstSubmorph contents: aString
]

{ #category : #'method protocol' }
SBRepl >> object [

	^ receiver
]

{ #category : #'artefact protocol' }
SBRepl >> printOn: aStream [

	aStream nextPutAll: 'workspace '.
	aStream nextPutAll: (self name truncateWithElipsisTo: 20)
]

{ #category : #'compilation cue protocol' }
SBRepl >> receiver [

	^ receiver
]

{ #category : #'compilation cue protocol' }
SBRepl >> receiver: anObject [

	anObject ifNotNil: [self name: (anObject asString truncateWithElipsisTo: 20)].
	receiver := anObject
]

{ #category : #'artefact protocol' }
SBRepl >> relatedClass [

	^ self methodClass
]

{ #category : #'artefact protocol' }
SBRepl >> saveTryFixing: aBoolean quick: aQuickBoolean [

	self allBlocksDo: [:block |
		block valid ifFalse: [
			"block isBinding ifTrue: [self addLocalBindingFor: block]."
			
			aBoolean ifFalse: [^ false] ifTrue: [block tryFixIfFail: [^ false]]]].
	
	^ true
]

{ #category : #'artefact protocol' }
SBRepl >> setFromSelection: aSelectionBlock [

	self body removeAllMorphs.
	aSelectionBlock childSandblocksDo: [:block |
		self body addMorphBack: block]
]

{ #category : #'artefact protocol' }
SBRepl >> setFromSource: aString [

	self removeMorph: self lastSubmorph.
	self addMorphBack: aString parseAsSandblock
]

{ #category : #'artefact protocol' }
SBRepl >> statements: aCollection [

	self body statements: aCollection
]

{ #category : #'as yet unclassified' }
SBRepl >> storeOn: aStream [

	SBExample self: [SBRepl newFromSource: '5 + 5 squared' named: 'REPL'] args: [{'' writeStream}] label: 'simple'.
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
SBRepl >> textContents [

	^ self name
]

{ #category : #'artefact protocol' }
SBRepl >> typeCache [

	^ typeCache
]

{ #category : #'artefact protocol' }
SBRepl >> typeFor: aBlock [

	^ self typeCache at: aBlock ifAbsent: [nil]
]

{ #category : #'artefact protocol' }
SBRepl >> veryDeepCopyWith: deepCopier [

	| new previousReceiver |
	previousReceiver := self receiver.
	new := super veryDeepCopyWith: deepCopier.
	new receiver: previousReceiver.
	receiver := previousReceiver.
	^ new
]

{ #category : #'compilation cue protocol' }
SBRepl >> wantsInteractiveErrorCorrection [

	^ false
]

{ #category : #'compilation cue protocol' }
SBRepl >> writeSourceOn: aStream [

	self body writeSourceOn: aStream.
	aStream nextPutAll: ' value'
]
