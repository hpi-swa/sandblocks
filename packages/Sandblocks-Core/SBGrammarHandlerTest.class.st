Class {
	#name : #SBGrammarHandlerTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #tests }
SBGrammarHandlerTest >> testContinueBinaryMessage [

	| block editor send |
	send := SBStMessageSend new receiver: SBUnknown new selector: #+ arguments: {SBUnknown new}.
	block := '[]' parseAsSandblock.
	editor := self methodFor: block.
	block addMorphBack: send.
	editor startInput: send at: 0 replacingContents: false.
	editor selection keyStroke: (self keyboardEvent: $+).
	self assert: (block statements first isMessageSend and: [block statements first = send])
]

{ #category : #tests }
SBGrammarHandlerTest >> testDoNotJumpAfterCompletingUnknown [

	| block editor |
	block := '[]' parseAsSandblock.
	editor := self methodFor: block.
	
	block addMorphBack: block newNullBlock.
	block addMorphBack: block newNullBlock.
	
	editor startInput: block statements first at: 0 replacingContents: false.
	
	self send: (self keyboardEvent: $a) to: editor.
	self send: (self keyboardEvent: $b) to: editor.
	
	self assert: 'ab' equals: block statements first contents
]

{ #category : #tests }
SBGrammarHandlerTest >> testInsertNewStatement [

	| block editor |
	{
		SBStNumber new contents: '123'.
		SBStName new contents: 'abc'.
		SBStMessageSend new receiver: SBUnknown new selector: #abc arguments: #()
	} do: [:leaf |
		block := '[]' parseAsSandblock.
		editor := self methodFor: block.
		block addMorphBack: leaf.
		editor startInput: leaf at: 0 replacingContents: false.
		self send: (self keyboardEvent: Character cr) to: editor.
		self assert: block statements size = 2]
]

{ #category : #'as yet unclassified' }
SBGrammarHandlerTest >> testUndoAfterReplacingUnknown [

	| unknown editor body |
	unknown := SBUnknown new grammarHandler: SBStGrammarHandler new.
	editor := self methodFor: unknown.
	body := unknown parentSandblock.
	editor startInput: unknown at: 0 replacingContents: true.
	self send: (self keyboardEvent: $1) to: editor.
	self send: (self keyboardEvent: $2) to: editor.
	self assert: body statements first isNumberBlock.
	editor undo.
	self assert: body statements first isUnknown
]

{ #category : #tests }
SBGrammarHandlerTest >> testWrapWithArray [

	| block editor |
	{
		SBStNumber new contents: '123'.
		SBStName new contents: 'abc'.
		SBUnknown new grammarHandler: SBStGrammarHandler new
	} do: [:leaf |
		block := '[]' parseAsSandblock.
		editor := self methodFor: block.
		block addMorphBack: leaf.
		editor startInput: leaf at: 0 replacingContents: false.
		self send: (self keyboardEvent: ${) to: editor.
		self assert: block statements first isArrayBlock]
]

{ #category : #tests }
SBGrammarHandlerTest >> testWrapWithBinaryMessageSend [

	| block editor |
	{
		SBStNumber new contents: '123'.
		SBStName new contents: 'abc'.
		SBStMessageSend new receiver: SBUnknown new selector: #abc arguments: #()
	} with: {#yourself. #yourself. [:b | b messageParts first]} do: [:leaf :inputSelector |
		block := '[]' parseAsSandblock.
		editor := self methodFor: block.
		block addMorphBack: leaf.
		editor startInput: (inputSelector value: leaf) at: 0 replacingContents: false.
		editor selection keyStroke: (self keyboardEvent: $+).
		self assert: (block statements first isMessageSend and: [block statements first ~= leaf])]
]

{ #category : #tests }
SBGrammarHandlerTest >> testWrapWithMessageSend [

	| block editor |
	{
		SBStNumber new contents: '123'.
		SBStName new contents: 'abc'.
		SBStMessageSend new receiver: SBUnknown new selector: #abc arguments: #()
	} do: [:leaf |
		block := '[]' parseAsSandblock.
		editor := self methodFor: block.
		block addMorphBack: leaf.
		editor startInput: leaf lastDeepChild at: 0 replacingContents: false.
		self send: (self keyboardEvent: $ ) to: editor.
		self assert: (block statements first isMessageSend and: [block statements first ~= leaf]).
		self assert: block statements first messageParts first equals: editor selection]
]
