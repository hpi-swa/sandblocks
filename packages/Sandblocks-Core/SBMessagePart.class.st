Class {
	#name : #SBMessagePart,
	#superclass : #SBASTNode,
	#instVars : [
		'text'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBMessagePart >> actualContents [

	^ text contents
]

{ #category : #'as yet unclassified' }
SBMessagePart >> childSandblocksDo: aBlock [
]

{ #category : #'as yet unclassified' }
SBMessagePart >> contents [

	^ text contents, (self hasColon ifTrue: [':'] ifFalse: [''])
]

{ #category : #'as yet unclassified' }
SBMessagePart >> contents: aString [

	text contents: ((aString notEmpty and: [aString last = $:]) ifTrue: [aString allButLast] ifFalse: [aString])
]

{ #category : #'as yet unclassified' }
SBMessagePart >> continueInputInArgument: anEvent [

	self sandblockEditor startInput: (self adjacentBlock: 1) at: 0 replacingContents: false.
	^ self sandblockEditor selection keyStroke: anEvent
]

{ #category : #'as yet unclassified' }
SBMessagePart >> currentTextMorph [

	^ text
]

{ #category : #actions }
SBMessagePart >> deleteAround [
	<action>

	self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
		target: self messageSend;
		replacer: (SBName contents: self actualContents))
]

{ #category : #'as yet unclassified' }
SBMessagePart >> drawnColor [

	^ self messageSend drawnColor alpha: 0
]

{ #category : #'as yet unclassified' }
SBMessagePart >> fontToUse [

	^ super fontToUse emphasized: TextEmphasis bold emphasisCode
]

{ #category : #'as yet unclassified' }
SBMessagePart >> hasColon [

	^ self owner lastSubmorph ~= self and: [self isBinary not]
]

{ #category : #'as yet unclassified' }
SBMessagePart >> initialize [

	super initialize.
	
	self
		addMorphBack: (text := SBOwnTextMorph new emphasis: TextEmphasis bold);
		layoutPolicy: SBVerticalLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBMessagePart >> insertUnknownAfterAndInput: aBoolean [

	| new |
	self owner arguments size > 0 ifTrue: [^ self].
	
	new := SBUnknown new.
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
SBMessagePart >> isBinary [

	^ text contents notEmpty and: [text contents first isSpecial]
]

{ #category : #'as yet unclassified' }
SBMessagePart >> isFirstPart [

	^ self owner firstSubmorph = self
]

{ #category : #'as yet unclassified' }
SBMessagePart >> isMessagePart [

	^ true
]

{ #category : #'as yet unclassified' }
SBMessagePart >> isUnary [

	^ self owner lastSubmorph = self
]

{ #category : #'as yet unclassified' }
SBMessagePart >> keyStroke: anEvent [

	(anEvent keyCharacter = Character space or: [
		self actualContents notEmpty and: [self isBinary not and: [anEvent keyCharacter isSpecial]]]) ifTrue: [^ self wrapInMessageSend: anEvent].
	(anEvent keyCharacter = Character backspace and: [self actualContents isEmpty and: [self isFirstPart]]) ifTrue: [^ self messageSend tryDelete].
	((anEvent keyCharacter isAlphaNumeric or: [#($' $#) includes: anEvent keyCharacter]) and: [self isBinary]) ifTrue: [^ self continueInputInArgument: anEvent].
	anEvent keyCharacter = $: ifTrue: [^ self insertUnknownAfterAndInput: true].
	
	(({Character backspace. Character delete. $_} includes: anEvent keyCharacter) or: [(anEvent keyCharacter isSpecial and: [self actualContents isEmpty or: [self isBinary]]) or: [anEvent keyCharacter isAlphaNumeric and: [self actualContents isEmpty or: [self isBinary not]]]]) ifTrue: [
		text keyStroke: anEvent.
		(anEvent keyCharacter isSpecial and: [self actualContents size = 1 and: [self isFirstPart]]) ifTrue: [^ self insertUnknownAfterAndInput: false].
		self updateSuggestions]
]

{ #category : #'as yet unclassified' }
SBMessagePart >> messageSend [

	^ self parentSandblock
]

{ #category : #'as yet unclassified' }
SBMessagePart >> printOn: aStream [

	aStream
		nextPutAll: 'message part ';
		nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBMessagePart >> selectorContentsBeforeMe [

	^ self messageSend messageParts in: [:parts |
		((parts copyFrom: 1 to: (parts indexOf: self) - 1) collect: #contents) joinSeparatedBy: '']
]

{ #category : #'as yet unclassified' }
SBMessagePart >> startInputAt: aNumber replacingContents: aBoolean [

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
SBMessagePart >> stopEditing: aCommand [

	aCommand
		newText: self contents;
		newMorph: self.
	
	text stopEditing.
	
	self removeSuggestionMenu
]

{ #category : #'as yet unclassified' }
SBMessagePart >> symbols [

	^ self colorPolicy symbolsForMessagePart: self
]

{ #category : #'as yet unclassified' }
SBMessagePart >> textContents [

	^ self contents
]

{ #category : #'as yet unclassified' }
SBMessagePart >> updateSuggestions [

	| selector |
	selector := self selectorContentsBeforeMe, self contents.
	selector ifEmpty: [^ self].
	
	selector last = $: ifTrue: [selector := selector allButLast].
	
	self updateSuggestions: ((self messageSend actualReceiver completionSuggestionsFor: selector) collect: [:sel | SBSuggestionItem selector: sel label: 'send']) showNear: self
]

{ #category : #'as yet unclassified' }
SBMessagePart >> useSuggestion: aString [

	self messageSend useSuggestion: aString
]

{ #category : #'as yet unclassified' }
SBMessagePart >> wrapInCascade [
	<multiSelectAction>

	| cascade |
	self assert: self isSelected.
	cascade := SBCascade new.
	self sandblockEditor doMultiSelection: [:selected | | targets |
		targets := selected collect: #messageSend.
		(self sandblockEditor submorphsAreConsecutive: targets)
			ifFalse: [nil]
			ifTrue: [
				(SBWrapConsecutiveCommand newFor: self containingArtefact)
					targets: (selected collect: #messageSend);
					outer: SBCascade new;
					wrap: [:outer :inner |
						outer addMorphFront: inner first receiver.
						outer addAllMorphs: inner];
					wrapUndo: [:outer :inner |
						inner do: [:message | message receiver: outer receiver veryDeepCopy].
						outer removeAllMorphs]]]
]

{ #category : #'as yet unclassified' }
SBMessagePart >> wrapInMessageSend [
	<action>
	
	self messageSend wrapInMessageSend: ''
]

{ #category : #'as yet unclassified' }
SBMessagePart >> wrapInMessageSend: anEvent [

	self sandblockEditor endInput.
	^ self messageSend wrapInMessageSend: (anEvent keyCharacter isSpecial ifTrue: [anEvent keyCharacter asString] ifFalse: [''])
]
