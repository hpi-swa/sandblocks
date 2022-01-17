Class {
	#name : #SBStNewMessageSend,
	#superclass : #SBStASTNode,
	#instVars : [
		'pc'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #accessing }
SBStNewMessageSend >> actualReceiver [

	^ self receiver
]

{ #category : #accessing }
SBStNewMessageSend >> arguments [

	^ self messageParts collect: #argument
]

{ #category : #converting }
SBStNewMessageSend >> asLanguageBox: converter [
	<convert>
	<automatic>

	converter
		if: [self selector = 'eval:lang:' and: [self receiver isBinding and: [self receiver contents = 'SBLanguageBox']]]
		do: [
			SBLanguageBox new
				source: self arguments first contents
				lang: self arguments second contents]
]

{ #category : #converting }
SBStNewMessageSend >> asMessageSend: converter [
	<convert>

	converter if: [self receiver isNil] do: [self veryDeepCopy]
]

{ #category : #converting }
SBStNewMessageSend >> asOhmGrammar: converter [
	<convert>
	<automatic>

	converter
		if: [self selector = 'new:' and: [self receiver isBinding and: [self receiver contents = 'OhmGrammar']]]
		do: [SBOhmGrammar from: self arguments first contents]
]

{ #category : #converting }
SBStNewMessageSend >> asReactComponent: converter [
	<convert>
	<automatic>

	converter
		if: [self selector = 'build' and: [self receiver isMessageSend and: [self receiver selector = 'asElementBuilder']]]
		do: [
			SBStReactComponent new
				componentClass: self receiver receiver
				props: SBStArray new
				children: SBStArray new]
]

{ #category : #converting }
SBStNewMessageSend >> asWatch: converter [
	<convert>
	<automatic>

	converter
		if: [self selector = 'report:for:' and: [self receiver isBinding and: [self receiver contents = 'SBWatch']]]
		do: [
			SBWatch new
				identifier: self arguments second contents asNumber;
				expression: self arguments first veryDeepCopy;
				yourself]
]

{ #category : #testing }
SBStNewMessageSend >> canAppearInBlockBody [

	^ true
]

{ #category : #converting }
SBStNewMessageSend >> converterOptionsDo: aBlock [

	super converterOptionsDo: aBlock.
	SBStSubstitution allSubclassesDo: [:substitution |
		(substitution matches: self) ifTrue: [
			aBlock value: (SBConvertOption
				named: substitution prettyName
				do: [:converter | converter do: [substitution newFor: self]])]]
]

{ #category : #'insert/delete' }
SBStNewMessageSend >> deleteCommandFor: aBlock [

	aBlock = self receiver ifTrue: [
		^ self isUnary
			ifTrue: [
				SBReplaceCommand new
					target: self;
					replacer: (SBStName new contents: self messageParts first contents)]
			ifFalse: [
				SBReplaceCommand new
					target: self receiver;
					replacer: self newNullBlock]].
	
	^ self messageParts size = 1
		ifTrue: [
			self receiver
				ifNotNil: [
					SBReplaceCommand new
						target: self;
						replacer: self receiver]
				ifNil: [SBDeleteCommand new target: self]]
		ifFalse: [SBDeleteCommand new target: aBlock]
]

{ #category : #'testing hierarchy' }
SBStNewMessageSend >> fixedNumberOfChildren [

	^ false
]

{ #category : #'initialize-release' }
SBStNewMessageSend >> initialize [

	super initialize.
	
	pc := 0
]

{ #category : #'insert/delete' }
SBStNewMessageSend >> insertCommandRequest: aMorph near: aBlock before: aBoolean [

	self isUnary ifTrue: [^ self messageParts first unaryToKeywordCommand].
	self isKeywords ifTrue: [^ super insertCommandRequest: aMorph near: aBlock before: aBoolean].
	^ nil
]

{ #category : #testing }
SBStNewMessageSend >> insetWithoutReceiver [

	^ true
]

{ #category : #testing }
SBStNewMessageSend >> isBinary [

	^ (self selector allSatisfy: [:c | c isSpecial]) or: [self selector = '::']
]

{ #category : #testing }
SBStNewMessageSend >> isConstructor: aString for: aClass [

	^ (self receiver satisfies: #(#notNil #isBinding))
		and: [self receiver contents = aClass name]
		and: [self selector = aString]
]

{ #category : #testing }
SBStNewMessageSend >> isExpression [

	^ self receiver notNil
]

{ #category : #testing }
SBStNewMessageSend >> isKeywords [

	^ self selector first isLetter and: [self selector includes: $:]
]

{ #category : #testing }
SBStNewMessageSend >> isMessageSend [

	^ true
]

{ #category : #testing }
SBStNewMessageSend >> isUnary [

	^ self isKeywords not and: [self isBinary not]
]

{ #category : #layout }
SBStNewMessageSend >> layoutCommands [

	| partsLayout |
	partsLayout := self messageParts
		collect: #layoutCommands
		separatedBy: (SBAlgebraCommand softLineOrGap withGap: true).
	^ SBAlgebraCommand container
		morph: self;
		data: (self receiver
			ifNotNil: [{self receiver layoutCommands}, {SBAlgebraCommand indent data: {SBAlgebraCommand softLineOrGap withGap: true}, partsLayout}]
			ifNil: [partsLayout])
]

{ #category : #layout }
SBStNewMessageSend >> layoutInset [

	^ (self receiver isNil and: [self insetWithoutReceiver])
		ifTrue: [(SBEdgeInsets left: 20 right: 0 top: 0 bottom: 0) + super layoutInset]
		ifFalse: [super layoutInset]
]

{ #category : #accessing }
SBStNewMessageSend >> messageParts [

	^ self firstSubmorph isMessagePart
		ifTrue: [self submorphs]
		ifFalse: [self submorphs allButFirst]
]

{ #category : #'insert/delete' }
SBStNewMessageSend >> newEmptyChildNear: aBlock before: aBoolean [

	^ SBStNewMessagePart new selector: ':' argument: self newNullBlock
]

{ #category : #'object interface' }
SBStNewMessageSend >> objectInterfaceNear: aBlock at: aSymbol [

	aBlock = self receiver ifTrue: [
		aSymbol = #replace ifTrue: [^ SBInterfaces stExpression].
		aSymbol = #before ifTrue: [^ SBInterfaces never]].
	^ SBInterfaces stMessagePart
]

{ #category : #accessing }
SBStNewMessageSend >> pc [

	^ pc
]

{ #category : #accessing }
SBStNewMessageSend >> pc: aNumber [

	pc := aNumber
]

{ #category : #'as yet unclassified' }
SBStNewMessageSend >> possibleArgumentNamesFor: aString [

	| selector method |
	selector := aString asSymbol.
	self owner receiver guessClassExpensive ifNotNil: [:class | (class lookupSelector: selector) ifNotNil: [:meth | method := meth]].
	method ifNil: [
		method := (self systemNavigation allImplementorsOf: selector)
			at: 1
			ifPresent: [:ref | ref compiledMethod]
			ifAbsent: [nil]].
	method ifNil: [^ #()].
	^ method asSandblock arguments collect: #contents
]

{ #category : #accessing }
SBStNewMessageSend >> receiver [

	^ self firstSubmorph isMessagePart
		ifTrue: [nil]
		ifFalse: [self firstSubmorph]
]

{ #category : #accessing }
SBStNewMessageSend >> receiver: aBlock [

	self receiver ifNotNil: #delete.
	aBlock ifNotNil: [self addMorphFront: aBlock]
]

{ #category : #'initialize-release' }
SBStNewMessageSend >> receiver: aBlock selector: aSymbol arguments: aCollection [

	aBlock ifNotNil: [self addMorphBack: aBlock].
	
	(aSymbol keywords ifEmpty: [#('')]) withIndexDo: [:keyword :index |
		self addMorphBack: (SBStNewMessagePart new
			selector: keyword
			argument: (aCollection at: index ifAbsent: [nil]))]
]

{ #category : #accessing }
SBStNewMessageSend >> selector [

	^ ((self messageParts collect: #contents) joinSeparatedBy: ':'), ((self messageParts size > 1 or: [self messageParts first hasArgument and: [self messageParts first contents noneSatisfy: #isSpecial]])
		ifTrue: [':']
		ifFalse: [''])
]

{ #category : #input }
SBStNewMessageSend >> startInputAt: aNumber replacingContents: aBoolean [

	self sandblockEditor replaceInput: self messageParts first.
	^ self messageParts first startInputAt: aNumber replacingContents: aBoolean
]

{ #category : #'as yet unclassified' }
SBStNewMessageSend >> useSuggestion: aString [

	| possibleArgumentNames |
	possibleArgumentNames := self possibleArgumentNamesFor: aString.
	
	self sandblockEditor do: (SBCombinedCommand newWith: (Array streamContents: [:stream |
		aString keywords withIndexDo: [:partsContents :index | | p |
			p := partsContents copyReplaceAll: ':' with: ''.
			self messageParts
				at: index
				ifPresent: [:part |
					stream nextPut: (SBMutatePropertyCommand new
						target: part;
						selector: #contents;
						value: p;
						yourself)]
				ifAbsent: [
					stream nextPut: (SBInsertCommand new
						container: self;
						morph: ((self newEmptyChildNear: nil before: false)
							contents: p;
							argumentLabel: (possibleArgumentNames at: index ifAbsent: []));
						index: index + 1)]].
		
		self messageParts
			from: aString keywords size + 1
			to: self messageParts size
			do: [:part | stream nextPut: (SBDeleteCommand new target: part)].
		
		aString asSymbol isUnary
			ifTrue: [self messageParts first hasArgument ifTrue: [stream nextPut: (SBDeleteCommand new target: self messageParts first argument)]]
			ifFalse: [self messageParts first hasArgument ifFalse: [stream nextPut: self messageParts first unaryToKeywordCommand]]])).
	self inputNextUnknown
]

{ #category : #'colors and color policies' }
SBStNewMessageSend >> wantsExtraSpace [

	^ false
]

{ #category : #actions }
SBStNewMessageSend >> wrapInCascade [
	<action>

	self sandblockEditor do: (SBWrapCommand new
		outer: SBStCascade new;
		inner: self;
		wrap: [:outer :inner | outer receiver: self receiver messages: {self}])
]

{ #category : #printing }
SBStNewMessageSend >> writeSendSourceOn: aStream [

	self messageParts do: [:p | p writeSourceOn: aStream] separatedBy: [aStream space]
]

{ #category : #printing }
SBStNewMessageSend >> writeSourceOn: aStream [

	self receiver ifNotNil: [
		aStream nextPut: $(.
		self receiver writeSourceOn: aStream.
		aStream space.
		self messageParts do: [:p | p writeSourceOn: aStream] separatedBy: [aStream space].
		aStream nextPut: $)]
]
