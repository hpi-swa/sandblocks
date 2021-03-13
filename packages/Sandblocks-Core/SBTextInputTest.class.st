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
	
	editor startInput: block statements first at: 9e8 replacingContents: false.
	editor filterEvent: (self class keyboardEvent: $r) for: nil.
	editor filterEvent: (self class keyboardEvent: Character cr) for: nil.
	
	self assert: block statements first selector size > 5
]

{ #category : #'as yet unclassified' }
SBTextInputTest >> testCursorKeepsHorizontalPosition [

	| editor block |
	block := '[''abcdefg''. ''abcdefg''. ''abcdefg'']' parseAsSandblock.
	editor := self methodFor: block.
	
	editor startInput: block statements second at: 2 replacingContents: false.
	editor filterEvent: (self class keyboardEvent: Character arrowRight) for: nil.
	self tick.
	
	self assert: 3 equals: block statements second currentTextMorph cursor.
	editor filterEvent: (self class keyboardEvent: Character arrowDown) for: nil.
	self tick.
	self assert: 3 equals: block statements third currentTextMorph cursor.
	editor filterEvent: (self class keyboardEvent: Character arrowUp) for: nil.
	self tick.
	self assert: 3 equals: block statements second currentTextMorph cursor.
	
	" now from command mode "
	editor filterEvent: (self class keyboardEvent: Character arrowUp shift: true command: false) for: nil.
	self tick.
	editor filterEvent: (self class keyboardEvent: Character arrowDown) for: nil.
	self tick.
	self assert: 3 equals: block statements third currentTextMorph cursor.
	
	editor filterEvent: (self class keyboardEvent: Character arrowUp shift: true command: false) for: nil.
	self tick.
	editor filterEvent: (self class keyboardEvent: Character arrowUp) for: nil.
	self tick.
	self assert: 3 equals: block statements second currentTextMorph cursor
]

{ #category : #'as yet unclassified' }
SBTextInputTest >> testMultiSelectionThroughShiftClick [

	| editor block |
	block := '[3. 3]' parseAsSandblock.
	editor := self editorFor: block.
	
	block statements first startOrAddToMultiSelection.
	block statements second click: (self class mouseEventAt: block statements second center).
	
	self assert: #selection equals: editor mode
]

{ #category : #'as yet unclassified' }
SBTextInputTest >> testMultiSelectionThroughSpace [

	| editor block |
	block := '[3. 3]' parseAsSandblock.
	editor := self methodFor: block.
	
	block statements first startOrAddToMultiSelection.
	block statements second select.
	self assert: #selection equals: editor mode.
	
	editor filterEvent: (self class keyboardEvent: Character space) for: nil.
	
	self assert: #selection equals: editor mode.
	self assert: 2 equals: (editor multiSelection size)
]

{ #category : #'as yet unclassified' }
SBTextInputTest >> testSpaceDuringInput [

	| editor block |
	block := '[3]' parseAsSandblock.
	editor := self methodFor: block.
	
	editor startInput: block statements first at: 9e8 replacingContents: false.
	editor filterEvent: (self class keyboardEvent: Character space) for: nil.
	
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
	editor filterEvent: (self class keyboardEvent: Character space) for: nil.
	
	self assert: (block statements last isKindOf: SBEmptyLine)
]

{ #category : #'as yet unclassified' }
SBTextInputTest >> tick [

	World doOneCycle
]
