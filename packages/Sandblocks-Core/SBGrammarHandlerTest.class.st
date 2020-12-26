Class {
	#name : #SBGrammarHandlerTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #tests }
SBGrammarHandlerTest >> testContinueBinaryMessage [

	| block editor send |
	send := SBMessageSend new receiver: SBUnknown new selector: #+ arguments: {SBUnknown new}.
	block := '[]' parseAsSandblock.
	editor := self editorFor: block.
	block addMorphBack: send.
	editor startInput: send at: 0 replacingContents: false.
	editor selection keyStroke: (self keyboardEvent: $+).
	self assert: (block statements first isMessageSend and: [block statements first = send])
]

{ #category : #tests }
SBGrammarHandlerTest >> testDoNotJumpAfterCompletingUnknown [

	| block editor |
	block := '[]' parseAsSandblock.
	editor := self editorFor: block.
	
	block addMorphBack: block newNullBlock.
	block addMorphBack: block newNullBlock.
	
	editor startInput: block statements first at: 0 replacingContents: false.
	
	editor filterEvent: (self keyboardEvent: $a) for: nil.
	editor filterEvent: (self keyboardEvent: $b) for: nil.
	
	self assert: 'ab' equals: block statements first contents
]

{ #category : #tests }
SBGrammarHandlerTest >> testInsertNewStatement [

	| block editor |
	{
		SBNumber new contents: '123'.
		SBName new contents: 'abc'.
		SBMessageSend new receiver: SBUnknown new selector: #abc arguments: #()
	} do: [:leaf |
		block := '[]' parseAsSandblock.
		editor := self editorFor: block.
		block addMorphBack: leaf.
		editor startInput: leaf at: 0 replacingContents: false.
		editor selection keyStroke: (self keyboardEvent: Character cr).
		self assert: block statements size = 2]
]

{ #category : #tests }
SBGrammarHandlerTest >> testWrapWithArray [

	| block editor |
	{
		SBNumber new contents: '123'.
		SBName new contents: 'abc'.
		SBUnknown new.
		SBMessageSend new receiver: SBUnknown new selector: #abc arguments: #()
	} do: [:leaf |
		block := '[]' parseAsSandblock.
		editor := self editorFor: block.
		block addMorphBack: leaf.
		editor startInput: leaf at: 0 replacingContents: false.
		editor selection keyStroke: (self keyboardEvent: ${).
		self assert: block statements first isArrayBlock]
]

{ #category : #tests }
SBGrammarHandlerTest >> testWrapWithBinaryMessageSend [

	| block editor |
	{
		SBNumber new contents: '123'.
		SBName new contents: 'abc'.
		SBMessageSend new receiver: SBUnknown new selector: #abc arguments: #()
	} do: [:leaf |
		block := '[]' parseAsSandblock.
		editor := self editorFor: block.
		block addMorphBack: leaf.
		editor startInput: leaf at: 0 replacingContents: false.
		editor selection keyStroke: (self keyboardEvent: $+).
		self assert: (block statements first isMessageSend and: [block statements first ~= leaf])]
]

{ #category : #tests }
SBGrammarHandlerTest >> testWrapWithMessageSend [

	| block editor |
	{
		SBNumber new contents: '123'.
		SBName new contents: 'abc'.
		SBMessageSend new receiver: SBUnknown new selector: #abc arguments: #()
	} do: [:leaf |
		block := '[]' parseAsSandblock.
		editor := self editorFor: block.
		block addMorphBack: leaf.
		editor startInput: leaf at: 0 replacingContents: false.
		editor selection keyStroke: (self keyboardEvent: $ ).
		self assert: (block statements first isMessageSend and: [block statements first ~= leaf]).
		self assert: block statements first messageParts first equals: editor currentInput]
]
