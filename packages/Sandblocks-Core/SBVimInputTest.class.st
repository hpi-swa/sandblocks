Class {
	#name : #SBVimInputTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBVimInputTest >> testPrintableCharacterShortcut [

	| message editor |
	message := '5 + 2' parseAsSandblock.
	editor := self methodFor: message.
	editor startInput: message at: 2 replacingContents: false.
	editor filterEvent: (self keyboardEvent: $+) for: nil.
	
	self assert: message selector = '++'
]
