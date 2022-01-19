Class {
	#name : #SBMessagePartTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBMessagePartTest >> testAddColon [

	| message |
	message := self parse: '5 yourself'
]

{ #category : #'as yet unclassified' }
SBMessagePartTest >> testBinaryMessageEdit [

	| message editor |
	message := self parse: '5 + 2'.
	editor := self methodFor: message.
	editor startInput: message messageParts first at: 0 replacingContents: false.
	message messageParts first keyStroke: (self keyboardEvent: $-).
	self assert: message selector = '-+'.
	message messageParts first keyStroke: (self keyboardEvent: Character backspace).
	self assert: message selector = '+'.
	message messageParts first keyStroke: (self keyboardEvent: $4).
	self assert: message arguments first contents = '42'.
	self assert: message arguments first isSelected
]

{ #category : #'as yet unclassified' }
SBMessagePartTest >> testChangeDoesNothing [

	| message |
	message := self parse: '5 yourself'.
	self methodFor: message.
	message messageParts first select.
	message messageParts first changeToUnknown.
	self assert: message messageParts first isMessagePart
]

{ #category : #'as yet unclassified' }
SBMessagePartTest >> testDeleteAround [

	| block |
	block := self parse: '[5 yourself: 2 send: 8]'.
	self methodFor: block.
	
	block statements first messageParts second deleteAround.
	self assert: block statements first contents = 'send:'
]

{ #category : #'as yet unclassified' }
SBMessagePartTest >> testHasColon [

	| message |
	message := self parse: '5 yourself'.
	message selector: 'yourself' arguments: #().
	self deny: message messageParts first hasColon.
	message selector: 'yourself:' arguments: {SBUnknown new}.
	self assert: message messageParts first hasColon.
	message selector: '++' arguments: {SBUnknown new}.
	self deny: message messageParts first hasColon
]

{ #category : #'as yet unclassified' }
SBMessagePartTest >> testInsertMessagePartAtEnd [

	| message |
	message := self parse: 'a do: b'.
	self methodFor: message.
	message arguments last insertElementAfter.
	self assert: message selector = 'do::'.
	self assert: message arguments last isUnknown
]

{ #category : #'as yet unclassified' }
SBMessagePartTest >> testInsertMessagePartAtStart [

	| message |
	message := self parse: 'a do: b'.
	self methodFor: message.
	
	" noop "
	message receiver insertElementAfter.
	self assert: 'do:' equals: message selector.
	
	message messageParts first insertElementBefore.
	self assert: ':do:' equals: message selector
]

{ #category : #'as yet unclassified' }
SBMessagePartTest >> testInsertMessagePartBeforeEnd [

	| message |
	message := self parse: 'a do: b'.
	self methodFor: message.
	message arguments last insertElementAfter.
	self assert: 'do::' equals: message selector.
	self assert: message arguments last isUnknown
]

{ #category : #'as yet unclassified' }
SBMessagePartTest >> testPressColonInExistingMessage [

	| message argument part |
	message := self parse: '5 yourself: 2'.
	part := message messageParts first.
	argument := message arguments first.
	(self methodFor: message) startInput: message at: 3 replacingContents: false.
	part keyStroke: (self keyboardEvent: $:).
	self assert: message selector = 'yourself:'.
	self assert: message arguments first = argument
]

{ #category : #'as yet unclassified' }
SBMessagePartTest >> testTypeBinary [

	| receiver message editor |
	receiver := SBUnknown new grammarHandler: SBStGrammarHandler new.
	editor := self methodFor: receiver.
	receiver performAction: #wrapInMessageSend.
	message := receiver parentSandblock.
	
	self assert: message selector isEmpty.
	self assert: editor selection = message messageParts first.
	message messageParts first keyStroke: (self keyboardEvent: $+).
	self assert: message selector = '+'.
	self assert: message arguments size = 1.
	self assert: editor selection = message messageParts first.
	message messageParts first keyStroke: (self keyboardEvent: $-).
	self assert: message selector = '+-'.
	message messageParts first keyStroke: (self keyboardEvent: $').
	self assert: editor selection = message arguments first.
	self assert: message selector = '+-'
]

{ #category : #'as yet unclassified' }
SBMessagePartTest >> testUseSuggestion [

	| message editor |
	message := self parse: '5 yourself'.
	(editor := self methodFor: message)
		startInput: message
		at: 1
		replacingContents: false.
	message useSuggestion: 'yourself:'.
	self assert: message arguments last isSelected.
	self assert: message arguments first isUnknown.
	self assert: message selector = 'yourself:'.
	editor undo.
	self assert: message selector = 'yourself'.
	editor redo.
	self assert: message arguments first isUnknown.
	self assert: message selector = 'yourself:'.
	editor startInput: message at: 1 replacingContents: false.
	message useSuggestion: 'from:to:do:'.
	self assert: (message arguments allSatisfy: #isUnknown).
	editor undo.
	editor redo.
	self assert: (message arguments allSatisfy: #isUnknown).
	editor startInput: message at: 1 replacingContents: false.
	message useSuggestion: 'yourself'.
	self assert: message selector = 'yourself'.
	self assert: message messageParts first isSelected
]
