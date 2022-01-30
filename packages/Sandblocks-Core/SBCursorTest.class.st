Class {
	#name : #SBCursorTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBCursorTest >> expectedFailures [

	^ #(#testBoundsUpdateOnChanges)
]

{ #category : #'as yet unclassified' }
SBCursorTest >> testBoundsUpdateOnChanges [

	| string editor |
	string := SBStString new contents: ''.
	editor := self editorFor: string.
	
	self assert: editor cursor bounds equals: string bounds.
	
	editor startInput: string at: 1 replacingContents: false.
	editor keyStroke: (self keyboardEvent: $a).
	
	self assert: editor cursor bounds equals: string bounds
]

{ #category : #'as yet unclassified' }
SBCursorTest >> testConsecutiveInsertPositions [

	| body cursor editor |
	body := '[:a | 1]' parseAsSandblock.
	editor := self editorFor: body.
	cursor := editor cursor select: body bindings first.
	
	cursor moveHorizontal: 1.
	cursor moveHorizontal: 1.
	self
		assert: cursor cursorPosition
		structure: {#class -> SBCursorInsert. #adjacent -> body bindings first. #before -> false}.
	cursor moveHorizontal: 1.
	self
		assert: cursor cursorPosition
		structure: {#class -> SBCursorInsert. #adjacent -> body statements first. #before -> true}
]

{ #category : #'as yet unclassified' }
SBCursorTest >> testCursorKeepsHorizontalOffset [

	| editor block cursor |
	block := '[''abcdefg''. ''abcdefg''. ''abcdefg'']' parseAsSandblock.
	editor := self methodFor: block.
	block containingFloat
		position: 100 @ 20;
		fullBounds.
	
	cursor := editor cursor moveCursorClick: block statements second at: 0 @ 0.
	self tick.
	self assert: cursor cursorPosition structure: {#cursorIndex -> 1}.
	
	cursor moveCursorRight.
	cursor moveCursorRight.
	self tick.
	self assert: cursor cursorPosition structure: {#cursorIndex -> 3}.
	
	cursor moveCursorDown.
	cursor moveCursorDown.
	self tick.
	self assert: cursor cursorPosition structure: {#cursorIndex -> 3}.
	
	cursor moveCursorUp.
	cursor moveCursorDown.
	self tick.
	self assert: cursor cursorPosition structure: {#cursorIndex -> 3}
]

{ #category : #'as yet unclassified' }
SBCursorTest >> testMoveBackward [

	| body cursor num1 array num2 num3 editor |
	body := '[1. {2. 3}]' parseAsSandblock.
	editor := self editorFor: body.
	num1 := body statements first.
	array := body statements second.
	num2 := array childSandblocks first.
	num3 := array childSandblocks second.
	
	cursor := editor cursor select: num3.
	cursor moveHorizontal: -1.
	"self assert: cursor cursorPosition structure: {#class -> SBCursorSelect. #block -> num3}.
	cursor moveHorizontal: -1."
	self
		assert: cursor cursorPosition
		structure: {#class -> SBCursorInsert. #before -> true. #adjacent -> num3}.
	cursor moveHorizontal: -1.
	self
		assert: cursor cursorPosition
		structure: {#class -> SBCursorText. #block -> num2. #cursorIndex -> 2}.
	cursor moveHorizontal: -1.
	"cursor moveHorizontal: -1.
	self assert: cursor cursorPosition structure: {#class -> SBCursorSelect. #block -> num2}."
	cursor moveHorizontal: -1.
	self
		assert: cursor cursorPosition
		structure: {#class -> SBCursorInsert. #before -> true. #adjacent -> num2}.
	"cursor moveHorizontal: -1.
	self assert: cursor cursorPosition structure: {#class -> SBCursorSelect. #block -> array}."
	cursor moveHorizontal: -1.
	self
		assert: cursor cursorPosition
		structure: {#class -> SBCursorInsert. #before -> true. #adjacent -> array}.
	cursor moveHorizontal: -1.
	self assert: cursor cursorPosition structure: {#class -> SBCursorText. #block -> num1}
]

{ #category : #'as yet unclassified' }
SBCursorTest >> testMoveBackwardWordWise [

	| body cursor num1 num2 editor |
	body := '[1. 2]' parseAsSandblock.
	editor := self editorFor: body.
	num1 := body statements first.
	num2 := body statements second.
	
	cursor := editor cursor select: num2.
	self
		assert: cursor cursorPosition
		structure: {#class -> SBCursorText. #block -> num2. #cursorIndex -> 1}.
	cursor moveHorizontal: -1 wordWise: true.
	self
		assert: cursor cursorPosition
		structure: {#class -> SBCursorText. #block -> num1. #cursorIndex -> 1}
]

{ #category : #'as yet unclassified' }
SBCursorTest >> testMoveForward [

	| body cursor num1 array num2 num3 editor |
	body := '[1. {2. 3}]' parseAsSandblock.
	editor := self editorFor: body.
	num1 := body statements first.
	array := body statements second.
	num2 := array childSandblocks first.
	num3 := array childSandblocks second.
	
	cursor := editor cursor select: num1.
	self
		assert: cursor cursorPosition
		structure: {#class -> SBCursorText. #block -> num1. #cursorIndex -> 1}.
	cursor moveHorizontal: 1.
	cursor moveHorizontal: 1.
	self
		assert: cursor cursorPosition
		structure: {#class -> SBCursorInsert. #before -> false. #adjacent -> num1}.
	"cursor moveHorizontal: 1.
	self assert: cursor cursorPosition structure: {#class -> SBCursorSelect. #block -> array}."
	cursor moveHorizontal: 1.
	self
		assert: cursor cursorPosition
		structure: {#class -> SBCursorInsert. #container -> array. #adjacent -> nil. #before -> true}.
	"cursor moveHorizontal: 1.
	self assert: cursor cursorPosition structure: {#class -> SBCursorSelect. #block -> num2}."
	cursor moveHorizontal: 1.
	self assert: cursor cursorPosition structure: {#class -> SBCursorText. #block -> num2}.
	cursor moveHorizontal: 1.
	cursor moveHorizontal: 1.
	self
		assert: cursor cursorPosition
		structure: {#class -> SBCursorInsert. #before -> false. #adjacent -> num2}.
	"cursor moveHorizontal: 1.
	self assert: cursor cursorPosition structure: {#class -> SBCursorSelect. #block -> num3}"
]

{ #category : #'as yet unclassified' }
SBCursorTest >> testMoveForwardWordWise [

	| body cursor num1 array num2 num3 editor |
	body := '[1. {2. 3}]' parseAsSandblock.
	editor := self editorFor: body.
	num1 := body statements first.
	array := body statements second.
	num2 := array childSandblocks first.
	num3 := array childSandblocks second.
	
	cursor := editor cursor select: num1.
	self
		assert: cursor cursorPosition
		structure: {#class -> SBCursorText. #block -> num1. #cursorIndex -> 1}.
	cursor moveHorizontal: 1 wordWise: true.
	cursor moveHorizontal: 1 wordWise: true.
	self
		assert: cursor cursorPosition
		structure: {#class -> SBCursorText. #block -> num2. #cursorIndex -> 2}.
	cursor moveHorizontal: 1 wordWise: true.
	self
		assert: cursor cursorPosition
		structure: {#class -> SBCursorText. #block -> num3. #cursorIndex -> 2}
]

{ #category : #'as yet unclassified' }
SBCursorTest >> testOtherSelectClearsFollowHistory [

	| body cursor raised add num5 num2 editor |
	body := '[2 + 5 raisedTo: 3]' parseAsSandblock.
	raised := body statements first.
	add := raised receiver.
	num2 := add receiver.
	num5 := add arguments first.
	editor := self editorFor: body.
	
	cursor := editor cursor select: num5.
	cursor moveCursorLarger.
	cursor moveCursorLarger.
	self assert: cursor cursorPosition structure: {#class -> SBCursorSelect. #block -> add}.
	cursor moveCursorClick: raised at: 0 @ 0.
	self assert: cursor cursorPosition structure: {#class -> SBCursorSelect. #block -> raised}.
	cursor moveCursorSmaller.
	cursor moveCursorSmaller.
	self assert: cursor cursorPosition structure: {#class -> SBCursorSelect. #block -> num2}
]

{ #category : #'as yet unclassified' }
SBCursorTest >> testSelectLarger [

	| body cursor raised add num2 editor |
	body := '[2 + 5 raisedTo: 3]' parseAsSandblock.
	raised := body statements first.
	add := raised receiver.
	num2 := add receiver.
	editor := self editorFor: body.
	
	cursor := editor cursor select: body firstDeepChild.
	self
		assert: cursor cursorPosition
		structure: {#class -> SBCursorText. #block -> num2. #cursorIndex -> 1}.
	cursor moveCursorLarger.
	self assert: cursor cursorPosition structure: {#class -> SBCursorSelect. #block -> num2}.
	cursor moveCursorLarger.
	self assert: cursor cursorPosition structure: {#class -> SBCursorSelect. #block -> add}.
	cursor moveCursorLarger.
	self assert: cursor cursorPosition structure: {#class -> SBCursorSelect. #block -> raised}
]

{ #category : #'as yet unclassified' }
SBCursorTest >> testSelectSmaller [

	| body cursor raised add num2 editor |
	body := '[2 + 5 raisedTo: 3]' parseAsSandblock.
	raised := body statements first.
	add := raised receiver.
	num2 := add receiver.
	editor := self editorFor: body.
	
	cursor := SBBlockCursor new editor: editor; select: add.
	self assert: cursor cursorPosition structure: {#class -> SBCursorSelect. #block -> add}.
	cursor moveCursorSmaller.
	self assert: cursor cursorPosition structure: {#class -> SBCursorSelect. #block -> num2}.
	cursor moveCursorSmaller.
	self
		assert: cursor cursorPosition
		structure: {#class -> SBCursorText. #block -> num2. #cursorIndex -> 2}
]

{ #category : #'as yet unclassified' }
SBCursorTest >> testSelectSmallerFollowsHistory [

	| body cursor raised add num5 editor |
	body := '[2 + 5 raisedTo: 3]' parseAsSandblock.
	raised := body statements first.
	add := raised receiver.
	num5 := add arguments first.
	editor := self editorFor: body.
	
	cursor := editor cursor select: num5.
	cursor moveCursorLarger.
	cursor moveCursorLarger.
	cursor moveCursorLarger.
	self assert: cursor cursorPosition structure: {#class -> SBCursorSelect. #block -> raised}.
	cursor moveCursorSmaller.
	cursor moveCursorSmaller.
	self assert: cursor cursorPosition structure: {#class -> SBCursorSelect. #block -> num5}
]
