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
SBInlineBlock >> advanceParseFrom: aCursor index: aNumber [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> allElementsDo: aBlock [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> applyReplacements [
	<action>

	| replacements commands |
	replacements := SBInlineBlockReplace allSubclasses gather: [:class |
		(Pragma allNamed: #lang:match: in: class class) select: [:pragma |
			pragma arguments first = self factory name]].
	commands := Array streamContents: [:stream |
		self allBlocksDo: [:block |
			replacements do: [:pragma |
				SBTSQuery new execute: pragma arguments second against: block capturesDo: [:captures |
					(pragma methodClass theNonMetaClass
						perform: pragma selector
						with: captures) ifNotNil: [:cmd | stream nextPut: cmd]]]]].
	commands ifNotEmpty: [self sandblockEditor do: (SBCombinedCommand newWith: commands)]
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
SBInlineBlock >> buildWithFields: aStream alternatives: aDictionary [

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
SBInlineBlock >> childSymbolsDo: aBlock [

	self submorphsDo: [:morph |
		morph isInlineBlock ifTrue: [
			(morph isKindOf: SBInlineBlockSymbol)
				ifTrue: [aBlock value: morph]
				ifFalse: [morph childSymbolsDo: aBlock]]]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> childrenForQuery [

	^ Array streamContents: [:s | self submorphsDo: [:m | (m isKindOf: SBInlineBlock) ifTrue: [m childrenForQueryDo: [:child | s nextPut: child]]]]
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

	| recursionDepth |
	" to find a transition, we first go up all nested alternatives until we reach our top-level symbol
 if no matches were found, we do the same but allow one level of recursion

why: many grammars encode a deep subtype tree in the owner hierarchy, so we should always
first query the entire hierarchy as each element should have equal importance, before allowing
recursion, which tends to produce more complex, combined blocks"
	recursionDepth := 0.
	2 timesRepeat: [
		(Array streamContents: [:stream | | current |
			current := self currentTextMorph ifNil: [self] ifNotNil: [:t | t owner].
			[current notNil and: [current isInlineBlock]] whileTrue: [
				(current isKindOf: SBInlineBlockChoice) ifTrue: [
					(SBTSRuleExplore new
						maxRecursionDepth: recursionDepth;
						explore: current
							withNested: current firstBlock
							nestedBefore: aBoolean
							for: aString
							startSymbol: nil) ifNotEmpty: [:choices |
						choices do: [:block | block first setProperty: #rootBlock toValue: current].
						stream nextPutAll: choices]].
				current := current owner.
				(current notNil and: [current isInlineBlock and: [current inline not and: [current ~= self]]]) ifTrue: [current := nil]]]) ifNotEmpty: [:results | ^ SBTSRuleExplore deduplicateResults: results]].
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
SBInlineBlock >> containsEqual: aBlock [

	self allMorphsDo: [:morph | (morph isInlineBlock and: [morph hasSameContentsAs: aBlock]) ifTrue: [^ true]].
	^ false
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> convertedFor: anInterfaceCollection do: aBlock [

	anInterfaceCollection first = #isInlineBlock ifTrue: [
		SBToggledCode comment: '' active: 0 do: {[self halt]}.
		^ (SBTSRuleExplore new
			explore: anInterfaceCollection last
				withNested: self
				nestedBefore: false
				for: ''
				startSymbol: nil;
			deduplicate)
			ifNotEmpty: [:choices | aBlock value: choices first]
			ifEmpty: [nil]].
	
	^ super convertedFor: anInterfaceCollection do: aBlock
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

{ #category : #'as yet unclassified' }
SBInlineBlock >> differenceTo: aMorph labelsDo: aBlock [

	| ret |
	ret := nil.
	self labelDifferenceOf: aMorph do: [:a :b |
		ret ifNil: [
			ret := aBlock
				value: (String streamContents: [:stream |
					(a ownerChain select: [:morph | morph isKindOf: SBInlineBlockSymbol]) reversed
						do: [:morph | stream nextPutAll: morph type]
						separatedBy: [stream nextPutAll: ' >> ']])
				value: (String streamContents: [:stream |
					(b ownerChain select: [:morph | morph isKindOf: SBInlineBlockSymbol]) reversed
						do: [:morph | stream nextPutAll: morph type]
						separatedBy: [stream nextPutAll: ' >> ']])]].
	^ ret
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
SBInlineBlock >> firstDifferingBlocksWith: aMorph do: aBlock [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> firstDifferingBlocksWith: aMorph do: aBlock ifNone: anotherBlock [

	(self hasSameStructureAs: aMorph) ifFalse: [^ aBlock value: self value: aMorph].
	self submorphCount = aMorph submorphCount ifTrue: [
		self submorphs with: aMorph submorphs do: [:a :b |
			(a isKindOf: SBInlineBlock) ifTrue: [
				a firstDifferingBlocksWith: b do: aBlock ifNone: anotherBlock]]].
	^ anotherBlock value
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> firstDifferingUpBlocksWith: aMorph do: aBlock ifNone: anotherBlock [

	(self hasSameStructureAs: aMorph) ifFalse: [^ aBlock value: self value: aMorph].
	(self owner notNil and: [self owner isInlineBlock]) ifTrue: [^ self owner firstDifferingUpBlocksWith: aMorph owner do: aBlock ifNone: anotherBlock].
	^ anotherBlock value
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> fixedNumberOfChildren [

	^ self repeaterChild isNil
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

	^ aBlock isKindOf: self class
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
		layoutInset: 0;
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
SBInlineBlock >> inlineRoot [

	^ (self owner isInlineBlock and: [self owner inline not])
		ifTrue: [self]
		ifFalse: [self owner inlineRoot]
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

{ #category : #testing }
SBInlineBlock >> isBuilt [

	^ built
]

{ #category : #accessing }
SBInlineBlock >> isBuilt: aBoolean [

	built := aBoolean
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

{ #category : #testing }
SBInlineBlock >> isTemplate [

	^ true
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
SBInlineBlock >> labelDifferenceOf: aMorph do: aBlock [

	self submorphs size = aMorph submorphs size ifFalse: [^ false].
	
	self submorphs
		with: aMorph submorphs
		do: [:a :b | (a labelDifferenceOf: b do: aBlock) ifFalse: [^ false]].
	^ true
]

{ #category : #accessing }
SBInlineBlock >> language [

	^ self factory name
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> layoutCommands [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> layoutInset [

	^ self inline ifTrue: [0] ifFalse: [super layoutInset]
]

{ #category : #accessing }
SBInlineBlock >> leftMostChain [

	^ (self hasSubmorphs not or: [self firstSubmorph isInlineBlock not])
		ifTrue: [{self}]
		ifFalse: [{self}, self firstSubmorph leftMostChain]
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

{ #category : #accessing }
SBInlineBlock >> matchesQuery: aString [

	^ SBTSQuery new execute: aString against: self capturesDo: [:b | ]
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
SBInlineBlock >> newEmptyChildNear: aBlock before: aBoolean [

	self flag: #todo.
	" if we have multiple repeating elements, get the one near aBlock "
	^ self repeaterChild ifNotNil: [:c | c element instantiate]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> nonInlinedChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> numAlternativesIn: anExplore [

	^ 1
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> objectInterfaceNear: aBlock at: aSymbol [
	" we are abusing the protocol here: our overwritten convertedFor:do: recognizes
 this and does special handling. other handlers will get blocked by the false"

	^ {#isInlineBlock. [:o | false]. aSymbol = #replace ifTrue: [self] ifFalse: [self repeaterChild element]}
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> preferredColorIn: aColorPolicy [

	^ highlight
		caseOf: {
			['keyword'] -> [aColorPolicy keyword].
			['function'] -> [aColorPolicy identifier].
			['comment'] -> [aColorPolicy defaultLight].
			['variable'] -> [aColorPolicy identifier].
			['type'] -> [aColorPolicy keyword].
			['number'] -> [aColorPolicy literal].
			['string'] -> [aColorPolicy literal].
			['escape'] -> [aColorPolicy literal].
			['punctuation.bracket'] -> [aColorPolicy builtIn].
			['operator'] -> [aColorPolicy identifier].
			['property'] -> [aColorPolicy identifier]}
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
SBInlineBlock >> printSExpr [

	^ String streamContents: [:s | self printSExprOn: s depth: 0]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> printSExprOn: aStream depth: aNumber [

	self childSymbolsDo: [:m |
		m printSExprOn: aStream depth: aNumber.
		aStream crtab: aNumber]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> printTitleOn: aStream [

	^ self subclassResponsibility
]

{ #category : #accessing }
SBInlineBlock >> query: aString capturesDo: aBlock [

	^ SBTSQuery new execute: aString against: self capturesDo: aBlock
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> removedMorph: aMorph [

	super removedMorph: aMorph.
	self extent: 0 @ 0
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> repeaterChild [

	self submorphsDo: [:m | (m isSandblock not and: [m isInlineBlock]) ifTrue: [m repeaterChild ifNotNil: [:c | ^ c]]].
	^ nil
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> statements [

	^ self isStatementContainer ifTrue: [self childSandblocks] ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> takeParseFrom: aCursor [

	^ self subclassResponsibility
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
SBInlineBlock >> tryInterpretInput: aString before: aBoolean [

	| selected |
	selected := SBTSBlockChooseDialog new
		do: [:query | self choicesForInput: query before: aBoolean]
		query: aString.
	selected ifNil: [^ self].
	
	self sandblockEditor do: (SBReplaceCommand new
		target: (selected valueOfProperty: #rootBlock);
		replacer: selected).
	selected removeProperty: #rootBlock.
	SBToggledCode comment: '' active: 1 do: {
		[
			selected firstBlock
				select;
				inputContainedUnknown].
		[selected inputContainedUnknown]}
]

{ #category : #accessing }
SBInlineBlock >> type [

	^ nil
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> unbuiltChildrenIn: anExplore [

	^ built ifTrue: [#()] ifFalse: [self childrenIn: anExplore]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> unwrapSuperType [

	^ self
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> updateAllHighlights [

	factory hasHighlight ifFalse: [^ self].
	
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
