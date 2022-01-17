Class {
	#name : #SBStBasicMethod,
	#superclass : #SBStASTNode,
	#instVars : [
		'methodClass',
		'typeCache',
		'currentSelector',
		'currentClass',
		'body',
		'category'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStBasicMethod class >> selector: aSymbol arguments: aCollection class: aClass body: aBlock [

	^ self new
		selector: aSymbol arguments: aCollection class: aClass;
		body: aBlock asSandblock
]

{ #category : #accessing }
SBStBasicMethod >> actualReceiver [

	^ self
]

{ #category : #'ast helpers' }
SBStBasicMethod >> allUsagesDo: aBlock [

	^ self sandblockEditor allBlocksDo: [:block |
		(block isMessageSend and: [
			block selector = self selector and: [
				block receiver guessClassExpensive = self methodClass]]) ifTrue: [aBlock value: block]]
]

{ #category : #accessing }
SBStBasicMethod >> arguments [

	^ Array streamContents: [:stream | self argumentsDo: [:a | a isUnknown not ifTrue: [stream nextPut: a]]]
]

{ #category : #'method protocol' }
SBStBasicMethod >> argumentsDo: aBlock [

	^ self subclassResponsibility
]

{ #category : #accessing }
SBStBasicMethod >> artefact [

	^ self compiledMethod
]

{ #category : #events }
SBStBasicMethod >> artefactChanged: aMethodBlock [

	aMethodBlock = self ifTrue: [ | currentHint |
		currentHint := self valueOfProperty: #renameHint.
		(self selector ~= self currentSelector and: [currentHint isNil and: [self exists]]) ifTrue: [ | hint |
			hint := SBIcon iconFilesO balloonText: 'Saving this method will rename it. Use <#saveCopy> instead to save a copy.' withSBShortcuts.
			self setProperty: #renameHint toValue: hint.
			self showRenameHint: hint].
		(self selector = self currentSelector and: [currentHint notNil]) ifTrue: [
			currentHint delete.
			self removeProperty: #renameHint]]
]

{ #category : #'ast helpers' }
SBStBasicMethod >> binding: aString for: block class: aClass ifPresent: aBlock [

	self argumentsDo: [:a | a contents = aString ifTrue: [^ aBlock value: a]].
	
	self instanceVariables
		detect: [:inst | inst contents = aString]
		ifFound: [:inst | ^ aBlock value: inst]
		ifNone: [].
	
	Symbol hasInterned: aString ifTrue: [:sym | | binding |
		binding := aClass bindingOf: sym environment: aClass environment.
		binding ifNotNil: [^ aBlock value: ((SBStName poolDeclaration: aString binding: binding) binding: binding)]].
	
	^ super binding: aString for: block class: aClass ifPresent: aBlock
]

{ #category : #'ast helpers' }
SBStBasicMethod >> blockBodyForPC: assocPc [

	self allBlocksDo: [:m | (m isBlockBody and: [m isSmalltalk and: [m startPC = assocPc]]) ifTrue: [^ m]].
	^ nil
]

{ #category : #'ast helpers' }
SBStBasicMethod >> blockForContext: aContext [

	^ self blockForPC: aContext pc
]

{ #category : #'ast helpers' }
SBStBasicMethod >> blockForPC: aNumber [

	self allBlocksDo: [:m | m pc = aNumber ifTrue: [^ m]].
	^ nil
	
	"| sortedBlocks |
	sortedBlocks := ((Array streamContents: [:stream | self allBlocksDo: [:m | stream nextPut: m]])
		sorted: [:a :b | a pc < b pc]).
	sortedBlocks overlappingPairsDo: [:current :next |
			(aNumber between: current pc and: next pc - 1) ifTrue: [^ current]].
	^ sortedBlocks last"
]

{ #category : #'ast helpers' }
SBStBasicMethod >> blockForSelector: aSymbol [

	self allBlocksDo: [:block |
		(block isMessageSend and: [block selector = aSymbol]) ifTrue: [^ block]].
	^ nil
]

{ #category : #'ast helpers' }
SBStBasicMethod >> blocksForVariableNamed: aString do: aBlock [

	self allBlocksDo: [:m | (m isBinding and: [m contents = aString]) ifTrue: [aBlock value: m]]
]

{ #category : #accessing }
SBStBasicMethod >> body [

	^ self submorphCount = 1 ifTrue: [nil] ifFalse: [self lastSubmorph]
]

{ #category : #accessing }
SBStBasicMethod >> body: aBlock [

	self addMorphBack: aBlock
]

{ #category : #actions }
SBStBasicMethod >> browse [
	<action>

	Browser newOnClass: self methodClass selector: self selector
]

{ #category : #caching }
SBStBasicMethod >> cacheType: aClass for: aBlock [

	self typeCache at: aBlock put: aClass
]

{ #category : #accessing }
SBStBasicMethod >> category [

	self example: [(SBStBasicMethod >> #category) asSandblock] args: [{}] label: 'example'.
	^ category ifNil: [self methodClass organization categoryOfElement: self currentSelector]
]

{ #category : #accessing }
SBStBasicMethod >> category: aString [

	category := aString
]

{ #category : #actions }
SBStBasicMethod >> changeToUnknown [
	<action>
	
	" ignore "
]

{ #category : #accessing }
SBStBasicMethod >> collapsed: aBoolean [

	self body visible not = aBoolean ifTrue: [^ self].
	
	self body
		visible: aBoolean not;
		disableLayout: aBoolean.
	
	(aBoolean not and: [self isSelected not]) ifTrue: [self select]
]

{ #category : #'ast helpers' }
SBStBasicMethod >> compileMethodObject [

	^ [(self methodClass newParser
		parse: self sourceString
		class: self methodClass
		noPattern: false
		notifying: nil
		ifFail: nil) generateWithTempNames] on: SyntaxErrorNotification do: [nil]
]

{ #category : #accessing }
SBStBasicMethod >> compiledMethod [

	^ (self methodClass ifNil: [^ self])
		compiledMethodAt: self currentSelector asSymbol
		ifAbsent: [self]
]

{ #category : #actions }
SBStBasicMethod >> createTestMethod [
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
	method := self sandblockEditor createArtefactInView: (SBStMethod new
		selector: guessedMethodName arguments: #() class: testClass;
		body: SBStBlockBody empty).
	self sandblockEditor startInput: method body statements first at: 1 replacingContents: true
]

{ #category : #accessing }
SBStBasicMethod >> currentClass [

	^ currentClass
]

{ #category : #accessing }
SBStBasicMethod >> currentClass: aClass [

	currentClass := aClass
]

{ #category : #accessing }
SBStBasicMethod >> currentSelector [
	" the selector this method is currently saved as "

	^ currentSelector
]

{ #category : #accessing }
SBStBasicMethod >> currentSelector: aString [

	currentSelector := aString
]

{ #category : #accessing }
SBStBasicMethod >> declarations [

	^ self arguments, self instanceVariables
]

{ #category : #actions }
SBStBasicMethod >> deleteMethod [
	<action>

	^ self sandblockEditor do: (SBStDeleteMethodCommand new target: self)
]

{ #category : #'artefact protocol' }
SBStBasicMethod >> ensureExpanded [

	self isCollapsed ifTrue: [self toggleCollapsed]
]

{ #category : #evaluate }
SBStBasicMethod >> evaluationContext [

	^ self sandblockEditor errors focusedArtefact = self ifTrue: [self sandblockEditor editor errors focusedContext] ifFalse: [nil]
]

{ #category : #evaluate }
SBStBasicMethod >> evaluationReceiver [

	^ self valueOfProperty: #evaluationReceiver ifAbsent: [
		self relatedClass isMeta
			ifTrue: [self relatedClass theNonMetaClass]
			ifFalse: [self relatedClass basicNew]]
]

{ #category : #testing }
SBStBasicMethod >> exists [

	^ self currentClass canUnderstand: self currentSelector
]

{ #category : #accessing }
SBStBasicMethod >> externalModification: aBoolean [

	^ self setProperty: #externalModificationFlag toValue: aBoolean
]

{ #category : #accessing }
SBStBasicMethod >> guessedClass [

	^ self relatedClass
]

{ #category : #events }
SBStBasicMethod >> handleDroppedBlock: aBlock event: anEvent adding: aBoolean near: aMorph [

	self tryUseAsSelf: aBlock unpackSelection
]

{ #category : #testing }
SBStBasicMethod >> hasExternalModification [

	^ self valueOfProperty: #externalModificationFlag ifAbsent: [false]
]

{ #category : #events }
SBStBasicMethod >> ignoreChangeNotifierDuring: aBlock [

	self setProperty: #ignoreChangeNotifier toValue: true.
	
	aBlock ensure: [self removeProperty: #ignoreChangeNotifier]
]

{ #category : #'initialize-release' }
SBStBasicMethod >> initialize [

	super initialize.
	
	self attachDecorator: SBForceMoveDecorator newConfigured
]

{ #category : #'action helpers' }
SBStBasicMethod >> insertStatementAboveOrBelow: anAboveBoolean [

	| statement |
	statement := self newNullBlock.
	self sandblockEditor
		do: (SBInsertCommand new
			index: (anAboveBoolean ifTrue: [2] ifFalse: [self body submorphCount + 1]);
			container: self body;
			morph: statement;
			shouldMergeWithNext: true;
			yourself);
		startInput: statement at: 1 replacingContents: false
]

{ #category : #accessing }
SBStBasicMethod >> instanceVariables [

	| editor |
	editor := self sandblockEditor.
	^ Array streamContents: [:stream |
		self methodClass withAllSuperclassesDo: [:class | | open |
			open := [class instVarNames collect: [:name | SBStName instanceVariable: name class: class]].
			stream nextPutAll: (SBToggledCode comment: '' active: 1 do: {
				[open value].
				[
					editor
						ifNil: open
						ifNotNil: [editor blockFor: class withInterfaces: #(#isEditor) ifOpen: [:c | c instanceVariables] ifClosed: open]]})]]
]

{ #category : #'initialize-release' }
SBStBasicMethod >> intoWorld: aWorld [

	super intoWorld: aWorld.
	SystemChangeNotifier uniqueInstance
		noMoreNotificationsFor: self;
		notify: self ofSystemChangesOfItem: #method using: #methodChanged:
]

{ #category : #testing }
SBStBasicMethod >> isArtefact [

	^ true
]

{ #category : #testing }
SBStBasicMethod >> isClassSide [

	^ self methodClass isClassSide
]

{ #category : #testing }
SBStBasicMethod >> isClassSideMethod [

	^ self relatedClass isMeta
]

{ #category : #testing }
SBStBasicMethod >> isCollapsed [

	^ self body visible not
]

{ #category : #testing }
SBStBasicMethod >> isEditor [

	^ true
]

{ #category : #testing }
SBStBasicMethod >> isInstanceSideMethod [

	^ self isClassSideMethod not
]

{ #category : #testing }
SBStBasicMethod >> isMethod [

	^ true
]

{ #category : #testing }
SBStBasicMethod >> isMyArgument: aBlock [

	self argumentsDo: [:b | aBlock = b ifTrue: [^ true]].
	^ false
]

{ #category : #testing }
SBStBasicMethod >> isTopLevel [

	^ true
]

{ #category : #events }
SBStBasicMethod >> methodChanged: anEvent [

	((self hasProperty: #ignoreChangeNotifier) not and: (anEvent item selector = self selector and: [anEvent item methodClass = self methodClass])) ifTrue: [
		anEvent isRemoved ifTrue: [^ self delete].
		anEvent isModified ifTrue: [
			^ self hasUnsavedChanges
				ifTrue: [self externalModification: true]
				ifFalse: [self reloadMethodInPlace]]]
]

{ #category : #accessing }
SBStBasicMethod >> methodClass [

	^ methodClass
]

{ #category : #accessing }
SBStBasicMethod >> methodComment: aCollection [

	aCollection ifNil: [^ self].
	
	self statements: (aCollection reversed collect: [:c | self newCommentBlock contents: c]), self statements
]

{ #category : #actions }
SBStBasicMethod >> moveToClass [
	<action>

	^ UIManager default chooseClassOrTrait ifNotNil: [:class | | classOrInstanceSide |
		(classOrInstanceSide := UIManager default chooseFrom: {'Instance Side'. 'Class Side'}) ~= 0 ifTrue: [
			self sandblockEditor do: (SBStMoveMethodCommand new
				method: self;
				toClass: (classOrInstanceSide = 2 ifTrue: [class class] ifFalse: [class])).
			self clearCache]]
]

{ #category : #actions }
SBStBasicMethod >> moveToClassSide [
	<action>
	<actionValidIf: #isInstanceSideMethod>

	self sandblockEditor do: (SBStMoveMethodCommand new
		method: self;
		toClass: self relatedClass class)
]

{ #category : #actions }
SBStBasicMethod >> moveToInstanceSide [
	<action>
	<actionValidIf: #isClassSideMethod>

	self sandblockEditor do: (SBStMoveMethodCommand new
		method: self;
		toClass: self relatedClass theNonMetaClass)
]

{ #category : #accessing }
SBStBasicMethod >> numArgs [

	^ self arguments size
]

{ #category : #'object interface' }
SBStBasicMethod >> object [

	^ self compiledMethod
]

{ #category : #'object interface' }
SBStBasicMethod >> objectInterface [

	^ SBInterfaces stMethod
]

{ #category : #'object interface' }
SBStBasicMethod >> objectInterfaceNear: aBlock at: aSymbol [

	^ aBlock isBlockBody
		ifTrue: [aSymbol = #replace ifTrue: [SBInterfaces stBlock] ifFalse: [SBInterfaces never]]
		ifFalse: [super objectInterfaceNear: aBlock at: aSymbol]
]

{ #category : #actions }
SBStBasicMethod >> openClassDefinition [
	<action>
	
	self sandblockEditor open: self relatedClass
]

{ #category : #'initialize-release' }
SBStBasicMethod >> outOfWorld: aWorld [

	SystemChangeNotifier uniqueInstance noMoreNotificationsFor: self.
	super outOfWorld: aWorld
]

{ #category : #actions }
SBStBasicMethod >> pasteReplace [
	<action>

	| cat cls editor new |
	editor := self sandblockEditor.
	cat := self category.
	cls := self currentClass.
	super pasteReplace.
	
	new := editor selection.
	new ~= self ifTrue: [
		new currentClass: cls.
		new category: cat.
		new hResizing: self hResizing.
		new vResizing: self vResizing.
		editor do: (SBDoItCommand new artefact: new).
		new select]
]

{ #category : #actions }
SBStBasicMethod >> pickSelf [
	<action>
	
	self tryUseAsSelf: (self outermostWorldMorph morphsAt: (Cursor crossHair showWhile: [Sensor waitButton])) first
]

{ #category : #caching }
SBStBasicMethod >> postDuplicateSelf [

	SBToggledCode comment: '' active: 0 do: {
		[
			currentSelector asSymbol isBinary ifTrue: [^ self shouldBeImplemented].
			self currentSelector: 'copy', currentSelector capitalized]}.
	self selector: self currentSelector arguments: self arguments class: self methodClass.
	
	super postDuplicateSelf.
	
	" mark a change as we're unsaved "
	self sandblockEditor do: (SBDoItCommand new artefact: self).
	
	self
		detachDecorators: SBForceMoveDecorator configured;
		attachDecorator: SBForceMoveDecorator newConfigured
]

{ #category : #accessing }
SBStBasicMethod >> pragmas [

	^ self statements select: [:s | s isPragma]
]

{ #category : #'colors and color policies' }
SBStBasicMethod >> prefersNoBorder [

	^ self sandblockEditor isSingleArtefactView
]

{ #category : #printing }
SBStBasicMethod >> printOn: aStream [

	aStream nextPutAll: 'method ';  nextPutAll: self selector
]

{ #category : #'artefact protocol' }
SBStBasicMethod >> relatedClass [

	^ self methodClass
]

{ #category : #actions }
SBStBasicMethod >> reloadArtefact [
	<action>

	self sandblockEditor select: self reloadMethodInPlace
]

{ #category : #caching }
SBStBasicMethod >> reloadMethodInPlace [

	| reloaded |
	self externalModification: false.
	reloaded := self compiledMethod asSandblock
		position: self position;
		hResizing: self hResizing;
		width: self width;
		yourself.
	self replaceBy: reloaded.
	reloaded withDecorator: SBForceMoveDecorator do: [:d | d createImplicitForces].
	^ reloaded
]

{ #category : #actions }
SBStBasicMethod >> saveCopy [
	<action>

	category := self category.
	self currentSelector: self selector.
	self sandblockEditor save.
	self valueOfProperty: #renameHint ifPresentDo: #delete
]

{ #category : #'artefact protocol' }
SBStBasicMethod >> saveTryFixing: aBoolean quick: aQuickBoolean [

	| text newSelector |
	self allBlocksDo: [:block | block valid ifFalse: [aBoolean ifFalse: [^ false] ifTrue: [block tryFixIfFail: [^ false]]]].
	
	(self hasExternalModification not or: [UIManager default confirm: 'Method may have changed elsewhere, continue?'])
		ifTrue: [self externalModification: false]
		ifFalse: [^ false].
	
	text := aQuickBoolean ifTrue: [self sourceString] ifFalse: [self prettySourceString].
	
	self ignoreChangeNotifierDuring: [
		newSelector := self methodClass compile: text asText classified: self category.
		(self currentClass object ~= self methodClass object or: [self currentSelector ~= #'' and: [newSelector ~= self currentSelector]]) ifTrue: [
			self clearCache.
			self currentClass removeSelector: self currentSelector]].
	self currentSelector: newSelector.
	self currentClass: self methodClass.
	
	aQuickBoolean ifFalse: [self updatePCs].
	^ true
]

{ #category : #'method protocol' }
SBStBasicMethod >> selector [

	^ self subclassResponsibility
]

{ #category : #'method protocol' }
SBStBasicMethod >> selector: aSymbol arguments: aCollection [

	^ self subclassResponsibility
]

{ #category : #accessing }
SBStBasicMethod >> selector: aSymbol arguments: aCollection class: aClass [

	methodClass := aClass.
	
	self currentSelector ifNil: [self currentSelector: aSymbol asSymbol].
	self currentClass ifNil: [self currentClass: aClass]
]

{ #category : #'method protocol' }
SBStBasicMethod >> showRenameHint: aMorph [

	^ self subclassResponsibility
]

{ #category : #accessing }
SBStBasicMethod >> statements [

	^ self body statements
]

{ #category : #accessing }
SBStBasicMethod >> statements: aCollection [

	(self body ifNil: [self body: SBStBlockBody empty. self body]) statements: aCollection
]

{ #category : #accessing }
SBStBasicMethod >> textContents [

	^ self selector
]

{ #category : #actions }
SBStBasicMethod >> toggleBreakOnEntry [
	<action>

	self sandblockEditor
		do: ((self statements first isMessageSend and: [self statements first selector = #break])
			ifTrue: [SBDeleteCommand new target: self statements first]
			ifFalse: [
				self body
					insertCommandRequest: (SBStMessageSend new receiver: (SBStName contents: 'self') selector: #break)
					near: nil
					before: true]);
		save: self tryFixing: true quick: false
]

{ #category : #actions }
SBStBasicMethod >> toggleCollapsed [
	<action>

	self body
		visible: self body visible not;
		disableLayout: self body visible not.
	
	(self body visible not and: [self isSelected not and: [self sandblockEditor notNil]]) ifTrue: [self select]
]

{ #category : #'action helpers' }
SBStBasicMethod >> tryUseAsSelf: anObject [

	(anObject class includesBehavior: self relatedClass) ifTrue: [
		self setProperty: #evaluationReceiver toValue: anObject.
		
		(Array streamContents: [:str | self allBlocksDo: [:block | (SBSelfThumbnailRepresentation matches: block) ifTrue: [str nextPut: block]]]) ifNotEmpty: [:selfs |
			self sandblockEditor do: (SBCombinedCommand newWith: (selfs collect: [:block |
				SBReplaceCommand new
					replacer: (SBSelfThumbnailRepresentation newFor: block);
					target: block])).
			" why do we need this? "
			Project current addDeferredUIMessage: [self layoutChanged]]]
]

{ #category : #accessing }
SBStBasicMethod >> typeCache [

	^ typeCache ifNil: [typeCache := WeakKeyDictionary new]
]

{ #category : #'artefact protocol' }
SBStBasicMethod >> typeFor: aBlock [

	^ typeCache ifNil: [nil] ifNotNil: [typeCache at: aBlock ifAbsent: [nil]]
]

{ #category : #caching }
SBStBasicMethod >> updatePCs [

	| method new old |
	method := self compiledMethod asSandblock.
	
	new := Array streamContents: [:stream | method allBlocksDo: [:block | stream nextPut: block]].
	old := Array streamContents: [:stream | self allBlocksDo: [:block | stream nextPut: block]].
	
	new size = old size ifTrue: [new with: old do: [:newBlock :oldBlock | (oldBlock isSmalltalk and: [newBlock isSmalltalk]) ifTrue: [oldBlock class == newBlock class ifTrue: [oldBlock updatePCFrom: newBlock]]]]
]

{ #category : #testing }
SBStBasicMethod >> valid [

	^ self selector isEmpty or: [
		(self selector first canBeIdentifierInitial and: [
			self selector allSatisfy: [:c | c isAlphaNumeric or: [c = $: or: [c = $_]]]]) or: [self selector allSatisfy: #isSpecial]]
]

{ #category : #'artefact protocol' }
SBStBasicMethod >> wantsInteractiveErrorCorrection [

	^ false
]

{ #category : #'method protocol' }
SBStBasicMethod >> writeSignatureSourceOn: aStream [

	^ self subclassResponsibility
]

{ #category : #printing }
SBStBasicMethod >> writeSourceOn: aStream [

	self writeSignatureSourceOn: aStream.
	aStream space.
	self body writeSourceOn: aStream
]
