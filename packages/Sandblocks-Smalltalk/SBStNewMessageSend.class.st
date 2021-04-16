Class {
	#name : #SBStNewMessageSend,
	#superclass : #SBStASTNode,
	#instVars : [
		'pc'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStNewMessageSend >> actualReceiver [

	^ self receiver
]

{ #category : #'as yet unclassified' }
SBStNewMessageSend >> arguments [

	^ self messageParts collect: #argument
]

{ #category : #'as yet unclassified' }
SBStNewMessageSend >> canAppearInBlockBody [

	^ true
]

{ #category : #'as yet unclassified' }
SBStNewMessageSend >> deleteCommandFor: aBlock [

	aBlock = self receiver ifTrue: [
		^ self isUnary
			ifTrue: [
				(SBReplaceCommand newFor: self containingArtefact)
					target: self;
					replacer: (SBStName new contents: self messageParts first contents)]
			ifFalse: [
				(SBReplaceCommand newFor: self containingArtefact)
					target: self receiver;
					replacer: (SBUnknown new grammarHandler: SBStGrammarHandler new)]].
	
	^ self messageParts size = 1
		ifTrue: [
			self receiver
				ifNotNil: [
					(SBReplaceCommand newFor: self containingArtefact)
						target: self;
						replacer: self receiver]
				ifNil: [(SBDeleteCommand newFor: self containingArtefact) target: self]]
		ifFalse: [(SBDeleteCommand newFor: self containingArtefact) target: aBlock]
]

{ #category : #'as yet unclassified' }
SBStNewMessageSend >> fixedNumberOfChildren [

	^ false
]

{ #category : #'initialize-release' }
SBStNewMessageSend >> initialize [

	super initialize.
	
	pc := 0
]

{ #category : #'as yet unclassified' }
SBStNewMessageSend >> insertCommandRequest: aMorph near: aBlock before: aBoolean [

	self isUnary ifTrue: [^ self messageParts first unaryToKeywordCommand].
	self isKeywords ifTrue: [^ super insertCommandRequest: aMorph near: aBlock before: aBoolean].
	^ nil
]

{ #category : #'as yet unclassified' }
SBStNewMessageSend >> insetWithoutReceiver [

	^ true
]

{ #category : #'as yet unclassified' }
SBStNewMessageSend >> isBinary [

	^ self selector allSatisfy: [:c | c isSpecial]
]

{ #category : #'as yet unclassified' }
SBStNewMessageSend >> isExpression [

	^ self receiver notNil
]

{ #category : #'as yet unclassified' }
SBStNewMessageSend >> isKeywords [

	^ self selector includes: $:
]

{ #category : #'as yet unclassified' }
SBStNewMessageSend >> isMessageSend [

	^ true
]

{ #category : #'as yet unclassified' }
SBStNewMessageSend >> isUnary [

	^ self isKeywords not and: [self isBinary not]
]

{ #category : #layout }
SBStNewMessageSend >> layoutCommands [

	| partsLayout |
	partsLayout := self messageParts
		collect: #layoutCommands
		separatedBy: SBAlgebraCommand softLine.
	^ SBAlgebraCommand container
		morph: self;
		data: (self receiver
			ifNotNil: [{self receiver layoutCommands}, {SBAlgebraCommand indent data: {SBAlgebraCommand softLineOrGap}, partsLayout}]
			ifNil: [partsLayout])
]

{ #category : #'as yet unclassified' }
SBStNewMessageSend >> layoutInset [

	^ (self receiver isNil and: [self insetWithoutReceiver])
		ifTrue: [(SBEdgeInsets left: 20 withScalingFactor right: 0 top: 0 bottom: 0) + super layoutInset]
		ifFalse: [super layoutInset]
]

{ #category : #accessing }
SBStNewMessageSend >> messageParts [

	^ self firstSubmorph isMessagePart
		ifTrue: [self submorphs]
		ifFalse: [self submorphs allButFirst]
]

{ #category : #'as yet unclassified' }
SBStNewMessageSend >> newNullBlock [

	^ SBStNewMessagePart new
		selector: ':'
		argument: (SBUnknown new grammarHandler: SBStGrammarHandler new)
]

{ #category : #'as yet unclassified' }
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

	(self systemNavigation allImplementorsOf: aString asSymbol) do: [:impl | ^ impl compiledMethod asSandblock arguments collect: #contents].
	^ #()
]

{ #category : #accessing }
SBStNewMessageSend >> receiver [

	^ self firstSubmorph isMessagePart
		ifTrue: [nil]
		ifFalse: [self firstSubmorph]
]

{ #category : #'initialize-release' }
SBStNewMessageSend >> receiver: aBlock selector: aSymbol arguments: aCollection [

	aBlock ifNotNil: [self addMorphBack: aBlock].
	
	aSymbol keywords withIndexDo: [:keyword :index |
		self addMorphBack: (SBStNewMessagePart new
			selector: keyword
			argument: (aCollection at: index ifAbsent: [nil]))]
]

{ #category : #'as yet unclassified' }
SBStNewMessageSend >> selector [

	^ ((self messageParts collect: #contents) joinSeparatedBy: ':'), ((self messageParts size = 1 and: [self messageParts first hasArgument and: [self messageParts first contents noneSatisfy: #isSpecial]])
		ifTrue: [':']
		ifFalse: [''])
]

{ #category : #'as yet unclassified' }
SBStNewMessageSend >> useSuggestion: aString [

	| possibleArgumentNames |
	possibleArgumentNames := self possibleArgumentNamesFor: aString.
	
	self sandblockEditor do: (SBCombinedCommand newWith: (Array streamContents: [:stream |
		aString keywords withIndexDo: [:partContents :index |
			partContents := partContents copyReplaceAll: ':' with: ''.
			self messageParts
				at: index
				ifPresent: [:part |
					stream nextPut: ((SBMutatePropertyCommand newFor: self containingArtefact)
						target: part;
						selector: #contents;
						value: partContents;
						yourself)]
				ifAbsent: [
					stream nextPut: ((SBInsertCommand newFor: self containingArtefact)
						container: self;
						morph: (self newNullBlock
							contents: partContents;
							argumentLabel: (possibleArgumentNames at: index ifAbsent: []));
						index: index + 1)]].
		
		self messageParts
			from: aString keywords size + 1
			to: self messageParts size
			do: [:part | stream nextPut: ((SBDeleteCommand newFor: self containingArtefact) target: part)].
		
		aString asSymbol isUnary
			ifTrue: [self messageParts first hasArgument ifTrue: [stream nextPut: ((SBDeleteCommand newFor: self containingArtefact) target: self messageParts first argument)]]
			ifFalse: [self messageParts first hasArgument ifFalse: [stream nextPut: self messageParts first unaryToKeywordCommand]]])).
	self inputNextUnknown
]

{ #category : #actions }
SBStNewMessageSend >> wrapInCascade [
	<action>

	
	self sandblockEditor do: ((SBWrapCommand newFor: self containingArtefact)
		outer: SBStCascade new;
		inner: self;
		wrap: [:outer :inner | outer receiver: self receiver messages: {self}])
]

{ #category : #'as yet unclassified' }
SBStNewMessageSend >> writeSourceOn: aStream [

	self receiver ifNotNil: [
		aStream nextPut: $(.
		self receiver writeSourceOn: aStream.
		aStream space.
		self messageParts do: [:p | p writeSourceOn: aStream].
		aStream nextPut: $)]
]
