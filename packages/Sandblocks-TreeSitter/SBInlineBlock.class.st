Class {
	#name : #SBInlineBlock,
	#superclass : #SBBlock,
	#instVars : [
		'name',
		'built',
		'highlight',
		'factory'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBInlineBlock >> actionProviders [

	^ {self grammarHandler}, super actionProviders
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> artefactChanged: aMethodBlock [

	aMethodBlock = self ifTrue: [self updateAllHighlights]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> buildCopy [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> buildDefault [

	^ self buildDefaultIn: nil
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> buildDefaultIn: anExplore [

	built := true
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> buildEmpty [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> candidatesForWrappingOn: aStream [

	(self hasSubmorphs and: [self firstSubmorph isInlineBlock]) ifTrue: [self firstSubmorph candidatesForWrappingOn: aStream]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> changeToUnknown [
	<action>

	self owner isInlineBlock ifTrue: [self owner changeToUnknown]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> childrenForQuery [

	^ Array streamContents: [:s | self submorphsDo: [:m | m childrenForQueryDo: [:child | s nextPut: child]]]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> childrenForQueryDo: aBlock [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> childrenIn: anExplore [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> choicesForInput: aString before: aBoolean [

	| current |
	current := self.
	[current notNil and: [current isInlineBlock]] whileTrue: [
		(current isKindOf: SBInlineBlockChoice) ifTrue: [
			(SBTSRuleExplore new
				explore: current
				withNested: self
				nestedBefore: aBoolean
				for: aString
				startSymbol: nil) ifNotEmpty: [:choices | ^ choices]].
		current := current owner].
	^ #()
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> clearCache [

	self allMorphsDo: [:morph | morph layoutChanged].
	self allMorphsDo: [:morph | (morph isSandblock or: [morph isInlineBlock]) ifTrue: [morph clearCacheSelf]]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> click: anEvent [

	self inline ifFalse: [super click: anEvent]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> containingSandblock [

	^ self inline ifTrue: [self owner ifNotNil: #containingSandblock] ifFalse: [self]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> currentTextMorph [

	self submorphsDo: [:m | (m isInlineBlock and: [m inline]) ifTrue: [m currentTextMorph ifNotNil: [:t | ^ t]]].
	^ nil
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> cursorPositionsDo: aBlock [

	self inline not ifTrue: [aBlock value: (SBCursorSelect new block: self)].
	self submorphsDo: [:m | m cursorPositionsDo: aBlock]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> deleteCommandFor: aBlock [

	^ (aBlock owner deleteTargetFor: aBlock)
		ifNotNil: [:target | SBDeleteCommand new target: target]
		ifNil: [
			aBlock newNullBlock ifNotNil: [:nullBlock |
				SBReplaceCommand new
					target: aBlock;
					replacer: nullBlock]]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> deleteTargetFor: aBlock [

	^ nil
]

{ #category : #geometry }
SBInlineBlock >> extent: aPoint [

	SBToggledCode
		comment: ''
		active: 1
		do: {[super extent: aPoint]. [super extent: (aPoint max: 0 @ self minimumHeight)]}
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> factory [

	^ factory
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> factory: aFactory [

	factory := aFactory
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> field [

	^ nil
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> firstDifferingBlocksWith: aMorph do: aBlock ifNone: anotherBlock [

	(self hasSameStructureAs: aMorph) ifFalse: [^ aBlock value: self value: aMorph].
	(self hasSubmorphs and: [aMorph hasSubmorphs and: [self firstSubmorph isInlineBlock]]) ifTrue: [
		^ self firstSubmorph
			firstDifferingBlocksWith: aMorph firstSubmorph
			do: aBlock
			ifNone: anotherBlock].
	^ anotherBlock value
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> firstDifferingUpBlocksWith: aMorph do: aBlock ifNone: anotherBlock [

	(self hasSameStructureAs: aMorph) ifFalse: [^ aBlock value: self value: aMorph].
	(self owner notNil and: [self owner isInlineBlock]) ifTrue: [^ self owner firstDifferingUpBlocksWith: aMorph owner do: aBlock ifNone: anotherBlock].
	^ anotherBlock value
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> grammarHandler [

	^ SBMetaGrammarHandler new
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> handlesMouseDown: anEvent [

	^ self inline not
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> handlesMouseOver: anEvent [

	^ self inline not
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> hasSameContentsAs: aBlock [

	^ aBlock class = self class
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> hasSameStructureAs: aBlock [

	^ aBlock class = self class
]

{ #category : #accessing }
SBInlineBlock >> highlight [

	^ highlight
]

{ #category : #accessing }
SBInlineBlock >> highlight: aString [

	highlight := aString
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> includesNestedSameStructure: aBlock [

	(self hasSameStructureAs: aBlock) ifTrue: [^ true].
	(self childrenIn: nil) do: [:morph | (morph includesNestedSameStructure: aBlock) ifTrue: [^ true]].
	^ false
]

{ #category : #'initialize-release' }
SBInlineBlock >> initialize [

	super initialize.
	
	built := false.
	
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		layoutPolicy: (SBToggledCode comment: '' active: 2 do: {[TableLayout new]. [SBAlgebraLayout new]});
		listDirection: #leftToRight;
		color: Color transparent;
		cellGap: 2;
		layoutInset: 2;
		cellPositioning: #center;
		extent: 0 @ 0
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> inline [

	^ false
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> inlineIfPossible [

	^ self owner notNil and: [self owner isInlineBlock and: [self owner nonInlinedChildren not]]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> insertCommandRequest: aMorph near: aBlock before: aBoolean [

	^ self owner inline
		ifTrue: [self owner insertCommandRequest: aMorph near: aBlock before: aBoolean]
		ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> instantiate [

	| instance |
	instance := self buildEmpty buildDefault.
	^ instance
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> isArtefact [

	^ self owner isNil or: [self owner isInlineBlock not]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> isBlockBody [

	^ self isStatementContainer
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> isInlineBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> isSandblock [

	^ self inline not
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> isStatement [

	^ self parentSandblock isInlineBlock and: [self parentSandblock isStatementContainer]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> isStatementContainer [

	^ false
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> keyStroke: anEvent [

	super keyStroke: anEvent.
	
	(self currentTextMorph notNil and: [self currentTextMorph owner valid not]) ifTrue: [
		self deleteBeforeCursor.
		
		self
			tryInterpretInput: (anEvent keyCharacter = Character space
				ifTrue: [(UIManager default request: 'type operator') ifEmpty: [^ self]]
				ifFalse: [anEvent keyCharacter asString])
			before: (anEvent keyCharacter = Character space and: [anEvent shiftPressed]) not]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> layoutCommands [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> layoutInset [

	^ self inline ifTrue: [0] ifFalse: [super layoutInset]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> leftMostRule [

	(self hasSubmorphs and: [self firstSubmorph isInlineBlock]) ifTrue: [^ self firstSubmorph leftMostRule]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> lengthOfLeftMostPath [

	^ self submorphCount > 0
		ifTrue: [1 + self firstSubmorph lengthOfLeftMostPath]
		ifFalse: [1]
]

{ #category : #geometry }
SBInlineBlock >> minimumHeight [

	^ TextStyle defaultFont height
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> name: aString [

	name := aString
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> nonInlinedChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> numAlternatives [

	^ 1
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> preferredColorIn: aColorPolicy [

	^ highlight
		caseOf: {
			['keyword'] -> [aColorPolicy keyword].
			['function'] -> [aColorPolicy identifier].
			['variable'] -> [aColorPolicy identifier].
			['type'] -> [aColorPolicy keyword].
			['number'] -> [aColorPolicy literal].
			['string'] -> [aColorPolicy literal]}
		otherwise: [aColorPolicy default]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> prefersNoBorder [

	^ self inline
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> printOn: aStream [

	SBToggledCode comment: '' active: 0 do: {[aStream nextPutAll: self className]}.
	aStream nextPut: $(.
	self printTitleOn: aStream.
	aStream nextPut: $)
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> printTitleOn: aStream [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> removedMorph: aMorph [

	super removedMorph: aMorph.
	self extent: 0 @ 0
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> statements [

	^ self isStatementContainer ifTrue: [self childSandblocks] ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> takeParsedFrom: aCursor [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> takeStreamFrom: aMorph [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> title [

	^ String streamContents: [:stream | self printTitleOn: stream]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> triggersFor: aString matchFullToken: aBoolean options: anOptions [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> tryInterpretInput: aString before: aBoolean [

	| choices |
	choices := self choicesForInput: aString before: aBoolean.
	choices size = 1 ifTrue: [
		self sandblockEditor do: (SBReplaceCommand new
			target: self;
			replacer: choices first).
		choices first inputContainedUnknown]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> unbuiltChildrenIn: anExplore [

	^ built ifTrue: [#()] ifFalse: [self childrenIn: anExplore]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> updateAllHighlights [

	self allMorphsDo: [:m | m isInlineBlock ifTrue: [m highlight: nil]].
	self updateHighlight
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> updateHighlight [

	self factory highlightQuery
		executeAgainst: self
		capturesDo: [:captures | captures keysAndValuesDo: [:id :block | block highlight ifNil: [block highlight: id]]].
	self submorphsDo: [:m | m isInlineBlock ifTrue: [m updateHighlight]]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> veryDeepCopyWith: deepCopier [

	| f copy |
	f := factory.
	factory := nil.
	copy := super veryDeepCopyWith: deepCopier.
	factory := f.
	copy factory: f.
	^ copy
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> wantsExtraSpace [

	^ self inline not
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> writeSourceOn: aStream [

	self subclassResponsibility
]
