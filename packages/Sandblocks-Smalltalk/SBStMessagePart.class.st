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

{ #category : #'as yet unclassified' }
SBStMessagePart >> childSandblocksDo: aBlock [
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> contents [

	^ text contents, (self hasColon ifTrue: [':'] ifFalse: [''])
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> contents: aString [

	text contents: ((aString notEmpty and: [aString last = $:]) ifTrue: [aString allButLast] ifFalse: [aString])
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> continueInputInArgument: anEvent [

	self sandblockEditor startInput: (self adjacentBlock: 1) at: 0 replacingContents: false.
	^ self sandblockEditor selection keyStroke: anEvent
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> currentTextMorph [

	^ text
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> deleteBeforeCursor [
	<inputAction>
	
	(self actualContents isEmpty and: [self isFirstPart]) ifTrue: [^ self messageSend tryDelete].
	self sandblockEditor deleteBeforeCursor
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> drawnColor [

	^ self messageSend drawnColor alpha: 0
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> evaluate [

	^ self messageSend evaluate
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> fontToUse [

	^ super fontToUse emphasized: TextEmphasis bold emphasisCode
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> hasColon [

	^ self owner ifNil: [false] ifNotNil: [self owner lastSubmorph ~= self and: [self isBinary not]]
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> initialize [

	super initialize.
	
	self
		addMorphBack: (text := SBOwnTextMorph new emphasis: TextEmphasis bold);
		layoutPolicy: SBAlgebraLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> insertUnknownAfterAndInput: aBoolean [

	| new |
	self owner arguments size > 0 ifTrue: [^ self].
	
	new := self newNullBlock.
	self sandblockEditor currentInputCommand shouldMergeWithNext: true.
	
	self sandblockEditor
		endInput;
		do: ((SBInsertCommand newFor: self containingArtefact)
			morph: new;
			container: self owner;
			shouldMergeWithNext: aBoolean;
			index: self childIndex + 1).
	self sandblockEditor startInput: (aBoolean ifTrue: [new] ifFalse: [self]) at: 9e8 replacingContents: false.
	
	" inform our symbols that we now #hasColon "
	self layoutChanged
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> isBinary [

	^ text contents notEmpty and: [text contents first isSpecial]
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> isFirstPart [

	^ self owner firstSubmorph = self
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> isMessagePart [

	^ true
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> isUnary [

	^ self owner lastSubmorph = self
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> keyStroke: anEvent [

	"(anEvent keyCharacter = Character space or: [
		self actualContents notEmpty and: [
			self isBinary not and: [anEvent keyCharacter isSpecial]]]) ifTrue: [^ self wrapInMessageSend: anEvent]."
	
	((anEvent keyCharacter isAlphaNumeric or: [#($' $#) includes: anEvent keyCharacter]) and: [self isBinary]) ifTrue: [^ self continueInputInArgument: anEvent].
	
	anEvent keyCharacter = $: ifTrue: [^ self insertUnknownAfterAndInput: true].
	
	(({Character backspace. Character delete. $_} includes: anEvent keyCharacter) or: [
		(anEvent keyCharacter isSpecial and: [self actualContents isEmpty or: [self isBinary]]) or: [
			anEvent keyCharacter isAlphaNumeric and: [
				self actualContents isEmpty or: [self isBinary not]]]]) ifTrue: [
		text keyStroke: anEvent.
		(anEvent keyCharacter isSpecial and: [
			self actualContents size = 1 and: [self isFirstPart]]) ifTrue: [^ self insertUnknownAfterAndInput: false].
		^ self updateSuggestions].
	
	SBStGrammarHandler new perform: anEvent keyCharacter for: self parentSandblock empty: false
]

{ #category : #'as yet unclassified' }
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
SBStMessagePart >> prefersNoBorder [

	^ true
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> printOn: aStream [

	aStream
		nextPutAll: 'message part ';
		nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> selectorContentsBeforeMe [

	^ self messageSend messageParts in: [:parts |
		((parts copyFrom: 1 to: (parts indexOf: self) - 1) collect: #contents) joinSeparatedBy: '']
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> startInputAt: aNumber replacingContents: aBoolean [

	| cmd |
	cmd := (SBInputCommand newFor: self containingArtefact)
		oldMorph: self;
		previousText: self contents;
		yourself.
	
	aBoolean ifTrue: [text contents: ''].
	text moveCursorTo: aNumber.
	
	^ cmd
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> stopEditing: aCommand [

	aCommand
		newText: self contents;
		newMorph: self.
	
	text stopEditing.
	
	self removeSuggestionMenu
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> symbols [

	^ self colorPolicy symbolsForMessagePart: self
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> textContents [

	^ self contents
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> updateSuggestions [

	| selector |
	selector := self selectorContentsBeforeMe, self contents.
	selector ifEmpty: [^ self].
	
	selector last = $: ifTrue: [selector := selector allButLast].
	
	self updateSuggestions: ((self messageSend actualReceiver completionSuggestionsFor: selector) collect: [:sel | SBSuggestionItem selector: sel label: 'send']) showNear: self
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> useSuggestion: aString [

	self messageSend useSuggestion: aString
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> wrapInCascade [
	<multiSelectAction>

	| cascade |
	self assert: self isSelected.
	cascade := SBStCascade new.
	self sandblockEditor doMultiSelection: [:selected | | targets |
		targets := selected collect: #messageSend.
		(self sandblockEditor submorphsAreConsecutive: targets)
			ifFalse: [nil]
			ifTrue: [
				(SBWrapConsecutiveCommand newFor: self containingArtefact)
					targets: (selected collect: #messageSend);
					outer: SBStCascade new;
					wrap: [:outer :inner |
						outer addMorphFront: inner first receiver.
						outer addAllMorphs: inner];
					wrapUndo: [:outer :inner |
						inner do: [:message | message receiver: outer receiver veryDeepCopy].
						outer removeAllMorphs]]]
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> wrapInMessageSend [
	<action>
	
	self messageSend grammarHandler wrapInMessageSend: ''
]

{ #category : #'as yet unclassified' }
SBStMessagePart >> wrapWithWatch [
	<action>
	<inputAction>

	self messageSend wrapWithWatch
]