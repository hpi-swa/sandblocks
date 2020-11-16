Class {
	#name : #SBBasicMethod,
	#superclass : #SBASTNode,
	#instVars : [
		'methodClass',
		'hasUnsavedChanges',
		'typeCache',
		'currentSelector',
		'currentClass',
		'body'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBBasicMethod class >> selector: aSymbol arguments: aCollection class: aClass body: aBlock [

	^ self new
		selector: aSymbol arguments: aCollection class: aClass;
		body: aBlock asSandblock
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> actualReceiver [

	^ self
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> allUsagesDo: aBlock [

	^ self sandblockEditor allBlocksDo: [:block |
		(block isMessageSend and: [
			block selector = self selector and: [
				block receiver guessClassExpensive = self methodClass]]) ifTrue: [aBlock value: block]]
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> arguments [

	^ Array streamContents: [:stream | self argumentsDo: [:a | stream nextPut: a]]
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> argumentsDo: aBlock [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> artefact [

	^ self compiledMethod
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> binding: aString for: block class: aClass ifPresent: aBlock [

	self argumentsDo: [:a | a contents = aString ifTrue: [^ aBlock value: a]].
	
	self instanceVariables detect: [:inst | inst contents = aString] ifFound: [:inst | ^ aBlock value: inst] ifNone: [].
	
	^ super binding: aString for: block class: aClass ifPresent: aBlock
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> blockForContext: aContext [

	^ self blockForPC: aContext pc
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> blockForPC: aNumber [

	self allBlocksDo: [:m | m pc = aNumber ifTrue: [^ m]].
	^ nil
	
	"| sortedBlocks |
	sortedBlocks := ((Array streamContents: [:stream | self allBlocksDo: [:m | stream nextPut: m]])
		sorted: [:a :b | a pc < b pc]).
	sortedBlocks overlappingPairsDo: [:current :next |
			(aNumber between: current pc and: next pc - 1) ifTrue: [^ current]].
	^ sortedBlocks last"
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> blockForSelector: aSymbol [

	self allBlocksDo: [:block |
		(block isMessageSend and: [block selector = aSymbol]) ifTrue: [^ block]].
	^ nil
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> blocksForVariableNamed: aString do: aBlock [

	self allBlocksDo: [:m | (m isBinding and: [m contents = aString]) ifTrue: [aBlock value: m]]
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> body [

	^ self submorphCount = 1 ifTrue: [nil] ifFalse: [self lastSubmorph]
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> body: aBlock [

	self addMorphBack: aBlock
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> browse [
	<action>

	Browser newOnClass: self methodClass selector: self selector
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> cacheType: aClass for: aBlock [

	self typeCache at: aBlock put: aClass
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> collapsed: aBoolean [

	self body visible not = aBoolean ifTrue: [^ self].
	
	self body
		visible: aBoolean not;
		disableLayout: aBoolean.
	
	(aBoolean not and: [self isSelected not]) ifTrue: [self select]
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> compiledMethod [

	^ self methodClass compiledMethodAt: self selector asSymbol ifAbsent: []
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> containingArtefact [

	^ self
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> contextAcceptedRepresentationAt: aNumber [

	aNumber = self childSandblocks size ifTrue: [^ #isSmalltalkBlock].
	^ #isSmalltalkName
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> createTestMethod [
	<action>

	| guessedClassName name testClass guessedMethodName method |
	guessedClassName := (self relatedClass name, 'Test') asSymbol.
	testClass := Smalltalk
		at: guessedClassName
		ifAbsent: [
			name := (UIManager default request: 'Test Class name?' initialAnswer: guessedClassName) ifEmpty: [^ self].
			Smalltalk
				at: name
				ifAbsent: [ 
					TestCase
						subclass: name asSymbol
						instanceVariableNames: #()
						classVariableNames: #()
						poolDictionaries: #()
						category: self relatedClass category, '-Tests']].
	guessedMethodName := ('test', self selector capitalized copyReplaceAll: ':' with: '') asSymbol.
	[
		testClass methodDictionary includesKey: guessedMethodName] whileTrue: [guessedMethodName := guessedMethodName, 'x'].
	method := self sandblockEditor openMorphInView: (SBMethod new
		selector: guessedMethodName arguments: #() class: testClass;
		hasUnsavedChanges: true;
		body: SBBlockBody empty).
	self sandblockEditor startInput: method body statements first at: 1 replacingContents: true
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> currentClass [

	^ currentClass
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> currentClass: aClass [

	currentClass := aClass
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> currentSelector [
	" the selector this method is currently saved as "

	^ currentSelector
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> currentSelector: aString [

	currentSelector := aString
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> declarations [

	^ self arguments, self instanceVariables
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> deleteMethod [
	<action>

	^ self sandblockEditor do: ((SBDeleteMethodCommand newFor: self) target: self)
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> drawSubmorphsOn: aCanvas [

	super drawSubmorphsOn: aCanvas.
	
	self hasUnsavedChanges ifTrue: [ | adornment |
		adornment  := PluggableTextMorph adornmentWithColor: Color orange.
		aCanvas image: adornment at: self position + (self width - adornment width @ 0)]
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> ensureExpanded [

	self isCollapsed ifTrue: [self toggleCollapsed]
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> evaluationContext [

	^ self sandblockEditor errorContextFor: self ifNone: [nil]
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> evaluationReceiver [

	^ self relatedClass basicNew
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> exists [

	^ self currentClass respondsTo: self currentSelector
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> externalModification: aBoolean [

	^ self setProperty: #externalModificationFlag toValue: aBoolean
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> hasExternalModification [

	^ self valueOfProperty: #externalModificationFlag ifAbsent: [false]
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> hasUnsavedChanges [

	^ hasUnsavedChanges
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> hasUnsavedChanges: aBoolean [

	hasUnsavedChanges ~= aBoolean ifTrue: [
		hasUnsavedChanges := aBoolean.
		self changed]
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> ignoreChangeNotifierDuring: aBlock [

	self setProperty: #ignoreChangeNotifier toValue: true.
	
	aBlock ensure: [self removeProperty: #ignoreChangeNotifier]
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> initialize [

	super initialize.
	
	self
		hasUnsavedChanges: false;
		attachDecorator: SBMoveDecorator new
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ signature insertCommandRequest: anAfterBoolean near: aBlock
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> insertStatementAboveOrBelow: anAboveBoolean [

	| statement |
	statement := SBUnknown new.
	self sandblockEditor
		do: ((SBInsertCommand newFor: self)
			index: (anAboveBoolean ifTrue: [2] ifFalse: [self body submorphCount + 1]);
			container: self body;
			morph: statement;
			shouldMergeWithNext: true;
			yourself);
		startInput: statement at: 1 replacingContents: false
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> instanceVariables [

	| editor |
	editor := self sandblockEditor.
	^ Array streamContents: [:stream |
		self methodClass withAllSuperclassesDo: [:class |
			editor
				ifNil: [class allInstVarNames collect: [:name | SBName instanceVariable: name]]
				ifNotNil: [
					editor blockForClass: class ifPresent: [:c | stream nextPutAll: c instanceVariables] ifAbsent: [
						class instVarNames do: [:name |
							stream nextPut: (SBName instanceVariable: name)]]]]]
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> intoWorld: aWorld [

	super intoWorld: aWorld.
	SystemChangeNotifier uniqueInstance
		noMoreNotificationsFor: self;
		notify: self ofSystemChangesOfItem: #method using: #methodChanged:
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> isArtefact [

	^ true
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> isClassSide [

	^ self methodClass isClassSide
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> isClassSideMethod [

	^ self relatedClass isMeta
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> isCollapsed [

	^ self body visible not
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> isInstanceSideMethod [

	^ self isClassSideMethod not
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> isMethod [

	^ true
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> isMyArgument: aBlock [

	self argumentsDo: [:b | aBlock = b ifTrue: [^ true]].
	^ false
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> methodChanged: anEvent [

	((self hasProperty: #ignoreChangeNotifier) not and: (anEvent item selector = self selector and: [anEvent item methodClass = self methodClass])) ifTrue: [
		anEvent isRemoved ifTrue: [^ self delete].
		(anEvent isModified) ifTrue: [^ self hasUnsavedChanges ifTrue: [self externalModification: true] ifFalse: [self reloadMethodInPlace]]]
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> methodClass [

	^ methodClass
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> moveToClass [
	<action>

	^ UIManager default chooseClassOrTrait ifNotNil: [:class | | classOrInstanceSide |
		(classOrInstanceSide := UIManager default chooseFrom: {'Instance Side'. 'Class Side'}) ~= 0 ifTrue: [
			self sandblockEditor do: ((SBMoveMethodCommand newFor: self)
				method: self;
				toClass: (classOrInstanceSide = 2 ifTrue: [class class] ifFalse: [class])).
			self clearCache]]
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> moveToClassSide [
	<action>
	<actionValidIf: #isInstanceSideMethod>

	self sandblockEditor do: ((SBMoveMethodCommand newFor: self)
		method: self;
		toClass: self relatedClass class)
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> moveToInstanceSide [
	<action>
	<actionValidIf: #isClassSideMethod>

	self sandblockEditor do: ((SBMoveMethodCommand newFor: self)
		method: self;
		toClass: self relatedClass theNonMetaClass)
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> object [

	^ self compiledMethod
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> openClassDefinition [
	<action>
	
	self sandblockEditor open: self relatedClass
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> outOfWorld: aWorld [

	SystemChangeNotifier uniqueInstance noMoreNotificationsFor: self
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> postDuplicateSelf [

	currentSelector asSymbol isBinary ifTrue: [^ self shouldBeImplemented].
	
	self currentSelector: 'copy', currentSelector capitalized.
	self selector: self currentSelector arguments: self arguments class: self methodClass.
	
	super postDuplicateSelf.
	
	self
		hasUnsavedChanges: true;
		detachDecorators: SBMoveDecorator;
		attachDecorator: SBMoveDecorator new
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> pragmas [

	^ self statements select: [:s | s isPragma]
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> printOn: aStream [

	aStream nextPutAll: 'method ';  nextPutAll: self selector
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> relatedClass [

	^ self methodClass
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> reloadMethod [
	<action>

	self sandblockEditor select: self reloadMethodInPlace
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> reloadMethodInPlace [

	self externalModification: false.
	^ self replaceBy: (self compiledMethod asSandblock position: self position)
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> saveTryFixing: aBoolean quick: aQuickBoolean [

	| text newSelector |
	(self savedMethodHasComments and: [(UIManager default confirm: 'Currently saved version has comments that will be removed. Still save?') not]) ifTrue: [^ false].
	
	self allBlocksDo: [:block |
		block valid ifFalse: [
			aBoolean ifFalse: [^ false] ifTrue: [block tryFixIfFail: [^ false]]]].
	
	(self hasExternalModification not or: [(UIManager default confirm: 'Method may have changed elsewhere, continue?')])
		ifTrue: [self externalModification: false]
		ifFalse: [^ false].
	
	text := aQuickBoolean ifTrue: [self sourceString] ifFalse: [self prettySourceString].
	
	self ignoreChangeNotifierDuring: [
		newSelector := self methodClass compile: text asText.
		(self currentClass ~= self methodClass or: [self currentSelector ~= #'' and: [newSelector ~=self  currentSelector]]) ifTrue: [
			self currentClass removeSelector: self currentSelector]].
	self currentSelector: newSelector.
	self currentClass: self methodClass.
	
	aQuickBoolean ifFalse: [self updatePCs].
	^ true
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> savedMethodHasComments [

	SBExample self: [
		SBMethod newFor: SBMethod >> #savedMethodHasComments at: 0 @ 0] args: [{}] label: 'no comment'.
	SBExample self: [SBMethod newFor: SBEditor >> #do: at: 0 @ 0] args: [{}] label: 'has comment'.
	^ self methodClass methodDictionary
		at: self selector asSymbol
		ifPresent: [:method | | scanner |
			scanner := Scanner new scan: method getSourceFromFile readStream.
			[
				scanner advance.
				scanner tokenType = #doIt] whileFalse: [scanner currentComment ifNotNil: [^ true]].
			false]
		ifAbsent: [false]
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> selector [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> selector: aSymbol arguments: aCollection [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> selector: aSymbol arguments: aCollection class: aClass [

	methodClass := aClass.
	
	self currentSelector ifNil: [self currentSelector: aSymbol asSymbol].
	self currentClass ifNil: [self currentClass: aClass]
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> statements [

	^ self body statements
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> stopEditing: aCommand [

	signature stopEditing: aCommand.
	self removeSuggestionMenu
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> textContents [

	^ self selector
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> toggleCollapsed [

	self body
		visible: self body visible not;
		disableLayout: self body visible not.
	
	(self body visible not and: [self isSelected not]) ifTrue: [self select]
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> typeCache [

	^ typeCache ifNil: [typeCache := Dictionary new]
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> typeFor: aBlock [

	^ typeCache ifNil: [nil] ifNotNil: [typeCache at: aBlock ifAbsent: [nil]]
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> updatePCs [

	| method new old |
	method := self compiledMethod asSandblock.
	
	new := Array streamContents: [:stream | method allBlocksDo: [:block | stream nextPut: block]].
	old := Array streamContents: [:stream | self allBlocksDo: [:block | stream nextPut: block]].
	
	new size = old size ifTrue: [new with: old do: [:newBlock :oldBlock | oldBlock isASTNode ifTrue: [oldBlock updatePCFrom: newBlock]]]
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> updateSuggestions [

	| selector |
	selector := (signature selector splitBy: ':') first.
	selector size > 2 ifTrue: [
		self updateSuggestions: (Array streamContents: [:stream | Symbol allSymbols do: [:sym | (sym asString sandblockMatch: selector) ifTrue: [stream nextPut: (SBSuggestionItem selector: sym label: 'method')]]]) showNear: signature]
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> useSuggestion: aString [

	signature selectorAndEdit: aString
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> valid [

	^ self selector notEmpty and: [
		(self selector first canBeIdentifierInitial and: [
			self selector allSatisfy: [:c | c isAlphaNumeric or: [c = $: or: [c = $_]]]]) or: [self selector allSatisfy: #isSpecial]]
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> wantsInteractiveErrorCorrection [

	^ false
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> writeSignatureSourceOn: aStream [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBBasicMethod >> writeSourceOn: aStream [

	self writeSignatureSourceOn: aStream.
	aStream space.
	self body writeSourceOn: aStream
]
