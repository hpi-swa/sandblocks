Class {
	#name : #SBTextInputTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBTextInputTest >> editorFor: aBlock [

	^ (super editorFor: aBlock) useTextInput
]

{ #category : #'as yet unclassified' }
SBTextInputTest >> methodFor: aBlock [

	^ (super methodFor: aBlock) useTextInput
]

{ #category : #'as yet unclassified' }
SBTextInputTest >> testAcceptAutoCompletion [

	| editor block |
	block := '[3 squa]' parseAsSandblock.
	editor := self methodFor: block.
	
	[editor openInWorld.
	editor startInput: block statements first messageParts first at: 9e8 replacingContents: false.
	self send: (self keyboardEvent: $r) to: editor.
	
	self tick.
	
	self send: (self keyboardEvent: Character tab) to: editor.
	
	self assert: block statements first selector size > 5] ensure: [editor delete]
]

{ #category : #'as yet unclassified' }
SBTextInputTest >> testCursorKeepsHorizontalPosition [

	| editor block |
	block := '[''abcdefg''. ''abcdefg''. ''abcdefg'']' parseAsSandblock.
	editor := self editorFor: block.
	block width: 10.
	block fullBounds.
	
	editor startInput: block statements second at: 2 replacingContents: false.
	self send: (self keyboardEvent: Character arrowRight) to: editor.
	self tick.
	
	self assert: 3 equals: block statements second currentTextMorph cursor.
	self send: (self keyboardEvent: Character arrowDown) to: editor.
	self send: (self keyboardEvent: Character arrowDown) to: editor.
	self tick.
	self assert: 3 equals: block statements third currentTextMorph cursor.
	self send: (self keyboardEvent: Character arrowUp) to: editor.
	self send: (self keyboardEvent: Character arrowUp) to: editor.
	self tick.
	self assert: 3 equals: block statements second currentTextMorph cursor
]

{ #category : #'as yet unclassified' }
SBTextInputTest >> testMultiSelectionThroughShiftClick [

	| editor block |
	block := '[3. 3]' parseAsSandblock.
	editor := self editorFor: block.
	
	block statements first startOrAddToMultiSelection.
	block statements second click: (self class mouseEventAt: block statements second center shift: true command: false control: false).
	
	self assert: #selection equals: editor mode
]

{ #category : #'as yet unclassified' }
SBTextInputTest >> testMultiSelectionThroughSpace [

	| editor block |
	block := '[3. 3]' parseAsSandblock.
	editor := self methodFor: block.
	
	block statements first startOrAddToMultiSelection.
	
	self send: (self keyboardEvent: Character arrowRight) to: editor.
	self assert: #selection equals: editor mode.
	self send: (self keyboardEvent: $ ) to: editor.
	
	self assert: #selection equals: editor mode.
	self assert: 2 equals: (editor multiSelection size)
]

{ #category : #'as yet unclassified' }
SBTextInputTest >> testSpaceDuringInput [

	| editor block |
	block := '[3]' parseAsSandblock.
	editor := self methodFor: block.
	
	editor startInput: block statements first at: 9e8 replacingContents: false.
	self send: (self keyboardEvent: $ ) to: editor.
	
	self assert: #input equals: editor mode.
	self assert: block statements first isMessageSend
]

{ #category : #'as yet unclassified' }
SBTextInputTest >> testSpaceForEmptyLine [

	| editor block space |
	block := '[3]' parseAsSandblock.
	editor := self methodFor: block.
	space := block newNullBlock.
	
	block addMorphBack: space.
	editor startInput: space at: 1 replacingContents: false.
	self send: (self keyboardEvent: $ ) to: editor.
	
	self assert: (block statements last isKindOf: SBUnknown)
]
