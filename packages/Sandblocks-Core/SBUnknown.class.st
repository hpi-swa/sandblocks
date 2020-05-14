Class {
	#name : #SBUnknown,
	#superclass : #SBLiteral,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBUnknown >> acceptCharacter: char [

	(char isDigit or: [char = $-]) ifTrue: [^ self doReplaceBy: (SBNumber new contents: char asString)].
	(char isAlphaNumeric or: [char = $_]) ifTrue: [^ self doReplaceBy: (SBName contents: char asString)].
	char = $$ ifTrue: [^ self doReplaceBy: (SBCharacter new contents: '')].
	char = $' ifTrue: [^ self doReplaceBy: (SBString new contents: '')].
	" currently incompatible because we continue with an InputCommand where would need a InputMessageCommand
	char = Character space ifTrue: [^ self doReplaceBy: (SBMessageSend new receiver: SBUnknown new selector: #'' arguments: #())]."
	char = $# ifTrue: [^ self doReplaceBy: (SBSymbol new contents: '')].
	
	char = ${ ifTrue: [^ self doWrap: [:outer :inner | outer type: #dynamic contents: {inner}] with: SBArray new].
	char = $[ ifTrue: [^ self doWrap: [:outer :inner | outer statements: {inner}] with: SBBlockBody new].
	char = $^ ifTrue: [^ self doWrap: [:outer :inner | outer expression: inner] with: SBReturn new].
	(char = $: and: [self parentSandblock isBlockBody]) ifTrue: [ | block |
		block := self parentSandblock.
		self sandblockEditor do: ((SBDeleteCommand newFor: self containingArtefact) target: self; shouldMergeWithNext: true).
		^ block addBlockArgument].
	char = $< ifTrue: [^ self replaceWithPragma]
]

{ #category : #'as yet unclassified' }
SBUnknown >> contents: aString [

	aString ifNotEmpty: [ | editor |
		editor := self sandblockEditor.
		self acceptCharacter: aString first.
		editor currentInput contents: editor currentInput contents, aString allButFirst]
]

{ #category : #'as yet unclassified' }
SBUnknown >> doReplaceBy: aMorph [

	self stopEditing.
	self replaceBy: aMorph.
	
	aMorph moveCursorTo: 9e8.
	aMorph sandblockEditor replaceInput: aMorph
]

{ #category : #'as yet unclassified' }
SBUnknown >> doWrap: aBlock with: aNode [

	self sandblockEditor
		endInput;
		do: ((SBWrapCommand newFor: self containingArtefact)
			inner: self;
			outer: aNode;
			shouldMergeWithNext: true;
			wrap: aBlock);
		startInput: self at: 0 replacingContents: false
]

{ #category : #'as yet unclassified' }
SBUnknown >> isUnknown [

	^ true
]

{ #category : #'as yet unclassified' }
SBUnknown >> keyStroke: anEvent [

	self acceptCharacter: anEvent keyCharacter
]

{ #category : #'as yet unclassified' }
SBUnknown >> printOn: aStream [

	aStream nextPutAll: 'unknown'
]

{ #category : #'as yet unclassified' }
SBUnknown >> replaceWithPragma [

	| pragma |
	pragma := SBPragma new.
	self stopEditing.
	self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
		target: self;
		replacer: pragma;
		shouldMergeWithNext: true).
	^ pragma sandblockEditor startInput: pragma at: 1 replacingContents: true
]

{ #category : #'as yet unclassified' }
SBUnknown >> valid [

	^ false
]

{ #category : #'as yet unclassified' }
SBUnknown >> writeSourceOn: aStream [

	self error: 'source is not valid because it contains non-filled values'
]
