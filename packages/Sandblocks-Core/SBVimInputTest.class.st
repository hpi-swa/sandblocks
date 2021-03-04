Class {
	#name : #SBVimInputTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBVimInputTest >> testEscapeLeavesInputMode [

	| message editor |
	message := '5' parseAsSandblock.
	editor := self methodFor: message.
	editor startInput: message at: 2 replacingContents: false.
	editor filterEvent: (self keyboardEvent: Character escape) for: nil.
	
	self assert: #command equals: editor mode
]

{ #category : #'as yet unclassified' }
SBVimInputTest >> testPrintableCharacterShortcut [

	| message editor |
	message := '5 + 2' parseAsSandblock.
	editor := self methodFor: message.
	editor startInput: message at: 2 replacingContents: false.
	editor filterEvent: (self keyboardEvent: $+) for: nil.
	
	self assert: message selector = '++'
]

{ #category : #'as yet unclassified' }
SBVimInputTest >> testSplitStringAtCursor [

	| block editor string |
	block := '[''abcd'']' parseAsSandblock.
	string := block childSandblocks first.
	
	editor := self methodFor: block.
	editor startInput: string at: 3 replacingContents: false.
	editor filterEvent: (self class keyboardEvent: $' shift: false command: true) for: nil.
	
	self assert: block childSandblocks first isMessageSend.
	self assert: 'ab' equals: block childSandblocks first receiver contents.
	self assert: 'cd' equals: block childSandblocks first arguments first contents
]
