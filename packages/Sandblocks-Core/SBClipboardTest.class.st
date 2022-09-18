Class {
	#name : #SBClipboardTest,
	#superclass : #SBTest,
	#instVars : [
		'oldClipboard'
	],
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #running }
SBClipboardTest >> setUp [

	super setUp.
	oldClipboard := Clipboard clipboardText
]

{ #category : #running }
SBClipboardTest >> tearDown [

	[oldClipboard ifNotNil: [Clipboard clipboardText: oldClipboard]] ensure: super tearDown
]

{ #category : #tests }
SBClipboardTest >> testCopyPasteBlock [

	| block from to |
	block := self parse: '[5. 6]'.
	self methodFor: block.
	from := block statements first.
	to := block statements second.
	
	from
		select;
		performAction: #copyToBuffer.
	to performAction: #pasteReplace.
	self assert: '5' equals: block statements second contents
]

{ #category : #tests }
SBClipboardTest >> testCopyString [

	| block from |
	block := self parse: '[5 squared]'.
	self methodFor: block.
	from := block statements first.
	
	from
		select;
		performAction: #copyToBuffer.
	self assert: '5 squared' equals: Clipboard clipboardText string
]

{ #category : #tests }
SBClipboardTest >> testPasteAfter [

	| block selection editor |
	block := self parse: '[a. b. c. self selected: 5]'.
	selection := block statements last.
	editor := self methodFor: block.
	block statements first select.
	(block statements viewFrom: 1 to: 3) do: #startOrAddToMultiSelection.
	block statements first copyToBuffer.
	selection pasteAfter.
	self assert: 'a' equals: block statements fifth contents.
	self assert: 'b' equals: block statements sixth contents.
	self assert: 'c' equals: block statements seventh contents
]

{ #category : #tests }
SBClipboardTest >> testPasteMultiple [

	| block selection editor |
	block := self parse: '[a. b. c. self selected: 5]'.
	selection := block statements last.
	editor := self methodFor: block.
	block statements first select.
	(block statements viewFrom: 1 to: 3) do: #startOrAddToMultiSelection.
	block statements first copyToBuffer.
	selection lastDeepChild select.
	editor performForSelection: #moveCursorRight.
	editor performForSelection: #moveCursorRight.
	editor performForSelection: #moveCursorRight.
	self assert: 'insert statement' equals: editor cursor cursorPosition command title.
	self assert: block equals: editor cursor cursorPosition command container.
	selection pasteReplace.
	self assert: 'a' equals: block statements fifth contents.
	self assert: 'b' equals: block statements sixth contents.
	self assert: 'c' equals: block statements seventh contents
]

{ #category : #tests }
SBClipboardTest >> testPasteString [

	| block from |
	block := self parse: '[5]'.
	self methodFor: block.
	from := block statements first.
	
	Clipboard clipboardText: '6'.
	from performAction: #pasteReplace.
	self assert: '6' equals: block statements first contents
]

{ #category : #tests }
SBClipboardTest >> testPasteStringAfterCopyBlock [

	| block from to |
	block := self parse: '[5. 6]'.
	self methodFor: block.
	from := block statements first.
	to := block statements second.
	
	from
		select;
		performAction: #copyToBuffer.
	Clipboard clipboardText: '6'.
	to performAction: #pasteReplace.
	self assert: '6' equals: block statements second contents
]
