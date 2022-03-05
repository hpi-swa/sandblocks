Class {
	#name : #SBStNewMessagePart,
	#superclass : #SBStASTNode,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> argument [

	^ self submorphCount = 3 ifTrue: [self lastSubmorph] ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> argumentLabel: aString [

	self argument label: aString
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> canDeleteChild: aBlock [

	^ self messageSend messageParts size = 1
]

{ #category : #actions }
SBStNewMessagePart >> changeToUnknown [
	<action>

	self sandblockEditor startInput: self at: 0 replacingContents: true
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> colon [

	^ self submorphs second
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> continueInputInArgument [

	self sandblockEditor currentInputCommand shouldMergeWithNext: true.
	self sandblockEditor startInput: self argument at: 0 replacingContents: false
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> currentTextMorph [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> drawnColor [

	^ self messageSend drawnColor alpha: 0
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> emphasis [

	^ self colorPolicy emphasisForMessagePart: self
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> ensureArgument [

	self hasArgument ifFalse: [self unaryToKeywordCommand do]
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> hasArgument [

	^ self submorphCount > 2
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> insertEmptyCommandRequestNear: aBlock before: aBoolean [

	^ self messageSend insertEmptyCommandRequestNear: aBlock before: aBoolean
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> isMessagePart [

	^ true
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> keyStroke: anEvent [

	super keyStroke: anEvent.
	
	(anEvent keyCharacter = $: or: [self contents allSatisfy: #isSpecial]) ifTrue: [
		self ensureArgument.
		anEvent keyCharacter = $: ifTrue: [
			self contents size = 1
				ifTrue: []
				ifFalse: [self currentTextMorph deleteBeforeCursor].
			^ self continueInputInArgument]].
	
	self valid ifFalse: [
		self currentTextMorph deleteBeforeCursor.
		self argument
			ifNotNil: [:a |
				self continueInputInArgument.
				a keyStroke: anEvent]
			ifNil: [
				SBStGrammarHandler new
					perform: anEvent keyCharacter
					for: self messageSend
					empty: false]]
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self submorphCount > 2
			ifTrue: [
				{
					self submorphs first layoutCommands.
					self submorphs second layoutCommands.
					SBAlgebraCommand gap.
					self submorphs third layoutCommands}]
			ifFalse: [{self firstSubmorph layoutCommands. self submorphs second layoutCommands}])
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> layoutInset [

	^ 0
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> messageSend [

	^ self parentSandblock
]

{ #category : #'action helpers' }
SBStNewMessagePart >> parentIsExpression [

	^ self parentSandblock isExpression
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> prefersNoBorder [

	^ true
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> selector [

	^ self messageSend selector
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> selector: aString argument: aBlockOrNil [

	self addMorphBack: (SBOwnTextMorph new
		contents: (aString copyReplaceAll: ':' with: '');
		placeholderText: 'msg';
		emphasis: #derive).
	self addMorphBack: (SBStringMorph new contents: (SBComputedString new value: [
		self contents = ':' ifTrue: ['='] ifFalse: [
			(self submorphCount = 3 and: [self contents noneSatisfy: #isSpecial])
				ifTrue: [':']
				ifFalse: ['']]])).
	aBlockOrNil ifNotNil: [self addMorphBack: aBlockOrNil]
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> selectorContentsBeforeMe [

	| parts |
	parts := self messageSend messageParts.
	^ ((parts copyFrom: 1 to: (parts indexOf: self) - 1) collect: #contents) joinSeparatedBy: ':'
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> startInputAt: aNumber replacingContents: aBoolean [

	| cmd |
	cmd := SBInputStructureCommand new
		oldMorph: self;
		previousText: self contents;
		oldMorphs: (self argument ifNotNil: [:a | {a}] ifNil: [{}]);
		yourself.
	aBoolean
		ifTrue: [
			self currentTextMorph
				contents: '';
				moveCursorTo: 0]
		ifFalse: [self currentTextMorph moveCursorTo: aNumber].
	^ cmd
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> startInputCommand [

	^ SBInputStructureCommand new
		oldMorph: self;
		previousText: self contents;
		oldMorphs: (self argument ifNotNil: [:a | {a}] ifNil: [{}]);
		yourself
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> stopEditing: aCommand [

	super stopEditing: aCommand.
	aCommand newMorphs: (self argument ifNotNil: [:a | {a}] ifNil: [{}])
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> suggestions [

	| selector |
	selector := self selectorContentsBeforeMe, self contents.
	
	(selector notEmpty and: [selector last = $:]) ifTrue: [selector := selector allButLast].
	
	^ self messageSend actualReceiver completionSuggestionsForSend: selector
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> unaryToKeywordCommand [

	^ SBInsertCommand new
		morph: self newNullBlock;
		container: self;
		index: 3
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> useSuggestion: anItem [

	self messageSend useSuggestion: anItem contents
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> valid [

	^ (self contents allSatisfy: #isSpecial) or: [self contents = ':' or: [self contents first canBeIdentifierInitial and: [self contents allSatisfy: [:c | c isAlphaNumeric or: [c = $_]]]]]
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> wantsExtraSpace [

	^ false
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> wantsInput [

	^ self contents isEmpty
]

{ #category : #actions }
SBStNewMessagePart >> wrapAsArgument [
	<action>
	<actionValidIf: #parentIsExpression>

	self parentSandblock
		select;
		performAction: #wrapAsArgument
]

{ #category : #actions }
SBStNewMessagePart >> wrapInBlock [
	<action>
	<actionValidIf: #parentIsExpression>

	self parentSandblock
		select;
		performAction: #wrapInBlock
]

{ #category : #actions }
SBStNewMessagePart >> wrapInDynamicArray [
	<multiSelectAction>
	<actionValidIf: #parentIsExpression>

	self parentSandblock
		select;
		performAction: #wrapInDynamicArray
]

{ #category : #actions }
SBStNewMessagePart >> wrapInMessageSend [
	<action>
	<actionValidIf: #parentIsExpression>

	self messageSend isUnary ifFalse: [^ self sandblockEditor startInput: self nextBlock at: 1 replacingContents: false].
	self messageSend grammarHandler
		block: self messageSend;
		wrapInMessageSend
]

{ #category : #actions }
SBStNewMessagePart >> wrapInReturn [
	<action>
	<actionValidIf: #parentIsExpression>

	self parentSandblock
		select;
		performAction: #wrapInReturn
]

{ #category : #actions }
SBStNewMessagePart >> wrapWithWatch [
	<action>
	<actionValidIf: #parentIsExpression>

	self messageSend performAction: #wrapWithWatch
]

{ #category : #'as yet unclassified' }
SBStNewMessagePart >> writeSourceOn: aStream [

	aStream nextPutAll: self contents.
	self argument ifNotNil: [:a |
		self contents first isSpecial ifFalse: [aStream nextPut: $:].
		aStream space.
		self argument writeSourceOn: aStream]
]
