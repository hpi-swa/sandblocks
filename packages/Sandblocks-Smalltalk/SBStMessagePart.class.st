Class {
	#name : #SBStMessagePart,
	#superclass : #SBStASTNode,
	#instVars : [
		'text'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStMessagePart >> actualContents [

	^ text contents
]

{ #category : #actions }
SBStMessagePart >> asName: aConverter [
	<convert>
	
	^ aConverter do: [SBStName new contents: self contents]
]

{ #category : #actions }
SBStMessagePart >> browse [

	self browseImplementors
]

{ #category : #testing }
SBStMessagePart >> canEvaluate [

	^ true
]

{ #category : #actions }
SBStMessagePart >> changeToUnknown [
	<action>

	self sandblockEditor startInput: self at: 0 replacingContents: true
]

{ #category : #accessing }
SBStMessagePart >> contents [

	^ text contents, self contentsSuffix
]

{ #category : #accessing }
SBStMessagePart >> contents: aString [

	aString = ':=' ifTrue: [
		text contents: ':'.
		^ self].
	
	text contents: ((aString notEmpty and: [aString last = $:])
		ifTrue: [aString allButLast]
		ifFalse: [aString])
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> contentsSuffix [

	text contents = ':' ifTrue: [^ '='].
	^ self hasColon ifTrue: [':'] ifFalse: ['']
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> continueInputInArgument: anEvent [

	self sandblockEditor startInput: (self adjacentBlock: 1) at: 0 replacingContents: false.
	^ self sandblockEditor selection keyStroke: anEvent
]

{ #category : #accessing }
SBStMessagePart >> currentTextMorph [

	^ text
]

{ #category : #actions }
SBStMessagePart >> deleteBeforeCursor [
	<inputAction>

	(self actualContents isEmpty and: [self isFirstPart]) ifTrue: [^ self messageSend tryDelete].
	super deleteBeforeCursor.
	
	
]

{ #category : #'colors and color policies' }
SBStMessagePart >> drawnColor [

	^ self messageSend ifNotNil: [:m | m drawnColor alpha: 0] ifNil: [super drawnColor]
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> emphasis [

	^ self colorPolicy emphasisForMessagePart: self
]

{ #category : #evaluate }
SBStMessagePart >> evaluate [

	^ self messageSend evaluate
]

{ #category : #accessing }
SBStMessagePart >> fontToUse [

	^ super fontToUse emphasized: self emphasis emphasisCode
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> hasColon [

	^ self owner
		ifNil: [false]
		ifNotNil: [self owner lastSubmorph ~= self and: [self isBinary not and: [text contents ~= ':=']]]
]

{ #category : #'initialize-release' }
SBStMessagePart >> initialize [

	super initialize.
	
	self
		addMorphBack: (text := SBOwnTextMorph new
			emphasis: #derive;
			placeholderText: 'msg';
			when: #contentsChanged send: #triggerEvent: to: self with: #contentsChanged);
		layoutPolicy: SBAlgebraLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> insertUnknownAfterAndInput: aBoolean [

	| new |
	self owner arguments size > 0 ifTrue: [
		^ aBoolean
			ifTrue: [
				self sandblockEditor
					startInput: self nextBlock firstDeepChild
					at: 1
					replacingContents: false]
			ifFalse: [self]].
	
	new := self newNullBlock label: 'arg'.
	self sandblockEditor currentInputCommand shouldMergeWithNext: true.
	
	self sandblockEditor do: (SBInsertCommand new
		morph: new;
		container: self owner;
		shouldMergeWithNext: aBoolean;
		index: self childIndex + 1).
	self sandblockEditor
		startInput: (aBoolean ifTrue: [new] ifFalse: [self])
		at: 900000000
		replacingContents: false.
	
	" inform our symbols that we now #hasColon "
	self layoutChanged
]

{ #category : #testing }
SBStMessagePart >> isAssignment [

	^ text contents = ':'
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> isBinary [

	^ text contents notEmpty and: [text contents first isSpecial]
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> isFirstPart [

	^ self owner firstSubmorph = self
]

{ #category : #testing }
SBStMessagePart >> isMessagePart [

	^ true
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> isUnary [

	^ self owner lastSubmorph = self
]

{ #category : #'event handling' }
SBStMessagePart >> keyStroke: anEvent [
	"(anEvent keyCharacter = Character space or: [
		self actualContents notEmpty and: [
			self isBinary not and: [anEvent keyCharacter isSpecial]]]) ifTrue: [^ self wrapInMessageSend: anEvent]."

	((anEvent keyCharacter isAlphaNumeric or: [#($' $#) includes: anEvent keyCharacter]) and: [self isBinary]) ifTrue: [^ self continueInputInArgument: anEvent].
	anEvent keyCharacter = $: ifTrue: [
		(self isFirstPart and: [self contents = ':' or: [self contents isEmpty]]) ifTrue: [self contents: ':='].
		^ self insertUnknownAfterAndInput: true].
	
	(({Character backspace. Character delete. $_} includes: anEvent keyCharacter) or: [(anEvent keyCharacter isSpecial and: [self actualContents isEmpty or: [self isBinary]]) or: [anEvent keyCharacter isAlphaNumeric and: [self actualContents isEmpty or: [self isBinary not]]]]) ifTrue: [
		super keyStroke: anEvent.
		(anEvent keyCharacter isSpecial and: [self actualContents size = 1 and: [self isFirstPart]]) ifTrue: [^ self insertUnknownAfterAndInput: false].
		^ self].
	
	self parentIsExpression ifTrue: [
		SBStGrammarHandler new
			perform: anEvent keyCharacter
			for: self parentSandblock
			empty: false]
]

{ #category : #layout }
SBStMessagePart >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {self firstSubmorph layoutCommands}
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> messageSend [

	^ self parentSandblock
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> parentIsExpression [

	^ self parentSandblock isExpression
]

{ #category : #'colors and color policies' }
SBStMessagePart >> prefersNoBorder [

	^ true
]

{ #category : #printing }
SBStMessagePart >> printOn: aStream [

	aStream
		nextPutAll: 'message part ';
		nextPutAll: self contents
]

{ #category : #accessing }
SBStMessagePart >> selector [

	^ self messageSend selector
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> selectorContentsBeforeMe [

	^ self messageSend messageParts in: [:parts |
		((parts copyFrom: 1 to: (parts indexOf: self) - 1) collect: #contents) joinSeparatedBy: '']
]

{ #category : #'event handling' }
SBStMessagePart >> startDrag: anEvent [

	self parentSandblock isMessageSend ifTrue: [self parentSandblock startDrag: anEvent]
]

{ #category : #input }
SBStMessagePart >> startInputAt: aNumber replacingContents: aBoolean [

	| cmd |
	cmd := SBInputCommand new
		oldMorph: self;
		previousText: self contents;
		yourself.
	
	aBoolean ifTrue: [text contents: ''].
	text moveCursorTo: aNumber.
	
	^ cmd
]

{ #category : #actions }
SBStMessagePart >> startOrAddToMultiSelection [
	<multiSelectAction>
	
	self messageSend startOrAddToMultiSelection
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> suggestions [

	| selector |
	selector := self selectorContentsBeforeMe, self contents.
	(selector notEmpty and: [selector last = $:]) ifTrue: [selector := selector allButLast].
	
	^ self messageSend actualReceiver completionSuggestionsForSend: selector
]

{ #category : #'colors and color policies' }
SBStMessagePart >> symbols [

	^ self colorPolicy symbolsForMessagePart: self
]

{ #category : #accessing }
SBStMessagePart >> textContents [

	^ self contents
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> useAsStSymbol [
	<action>
	<actionValidIf: #isUnary>

	self sandblockEditor do: (SBCombinedCommand newWith: {
		SBMutatePropertyCommand new target: self selector: #contents value: ''.
		SBInsertCommand new
			container: self owner;
			morph: (SBStSymbol new contents: self contents);
			index: self submorphIndex + 1})
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> useSuggestion: anItem [

	self messageSend useSuggestion: anItem contents
]

{ #category : #testing }
SBStMessagePart >> valid [

	^ self contents notEmpty and: [self contents ~= ':']
]

{ #category : #testing }
SBStMessagePart >> wantsInput [

	^ self currentTextMorph contents isEmpty
]

{ #category : #actions }
SBStMessagePart >> wrapAsArgument [
	<action>
	<actionValidIf: #parentIsExpression>

	self parentSandblock
		select;
		performAction: #wrapAsArgument
]

{ #category : #actions }
SBStMessagePart >> wrapInBlock [
	<action>
	<actionValidIf: #parentIsExpression>

	self parentSandblock
		select;
		performAction: #wrapInBlock
]

{ #category : #actions }
SBStMessagePart >> wrapInDynamicArray [
	<multiSelectAction>
	<actionValidIf: #parentIsExpression>

	self parentSandblock
		select;
		performAction: #wrapInDynamicArray
]

{ #category : #actions }
SBStMessagePart >> wrapInMessageSend [
	<action>
	<actionValidIf: #parentIsExpression>

	self messageSend isExpression ifFalse: [^ self].
	self isUnary ifFalse: [^ self sandblockEditor startInput: self nextBlock at: 1 replacingContents: false].
	
	self messageSend grammarHandler
		block: self messageSend;
		wrapInMessageSend
]

{ #category : #actions }
SBStMessagePart >> wrapWithExampleWatch [
	<action>
	<actionValidIf: #parentIsExpression>

	self messageSend performAction: #wrapWithExampleWatch
]

{ #category : #actions }
SBStMessagePart >> wrapWithWatch [
	<action>
	<actionValidIf: #parentIsExpression>

	self messageSend performAction: #wrapWithWatch
]

{ #category : #printing }
SBStMessagePart >> writeSourceOn: aStream [
	" probably meant to address my parent message send "
]
