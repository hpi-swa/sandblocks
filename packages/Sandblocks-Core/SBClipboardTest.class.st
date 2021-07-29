Class {
	#name : #SBClipboardTest,
	#superclass : #SBTest,
	#instVars : [
		'oldClipboard'
	],
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBClipboardTest >> setUp [

	super setUp.
	oldClipboard := Clipboard clipboardText
]

{ #category : #'as yet unclassified' }
SBClipboardTest >> tearDown [

	super tearDown.
	Clipboard clipboardText: oldClipboard
]

{ #category : #'as yet unclassified' }
SBClipboardTest >> testCopyPasteBlock [

	| block from to |
	block := '[5. 6]' parseAsSandblock.
	self methodFor: block.
	from := block statements first.
	to := block statements second.
	
	from
		select;
		performAction: #copyToBuffer.
	to performAction: #pasteReplace.
	self assert: '5' equals: block statements second contents
]

{ #category : #'as yet unclassified' }
SBClipboardTest >> testCopyString [

	| block from |
	block := '[5 squared]' parseAsSandblock.
	self methodFor: block.
	from := block statements first.
	
	from
		select;
		performAction: #copyToBuffer.
	self assert: '5 squared' equals: Clipboard clipboardText string
]

{ #category : #'as yet unclassified' }
SBClipboardTest >> testPasteAfter [

	| block selection editor |
	block := '[a. b. c. self selected: 5]' parseAsSandblock.
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

{ #category : #'as yet unclassified' }
SBClipboardTest >> testPasteMultiple [

	| block selection editor |
	block := '[a. b. c. self selected: 5]' parseAsSandblock.
	selection := block statements last.
	editor := self methodFor: block.
	block statements first select.
	(block statements viewFrom: 1 to: 3) do: #startOrAddToMultiSelection.
	block statements first copyToBuffer.
	selection startInputAtEnd.
	editor performForSelection: #moveCursorRight.
	selection pasteReplace.
	self assert: 'a' equals: block statements fifth contents.
	self assert: 'b' equals: block statements sixth contents.
	self assert: 'c' equals: block statements seventh contents
]

{ #category : #'as yet unclassified' }
SBClipboardTest >> testPasteString [

	| block from |
	block := '[5]' parseAsSandblock.
	self methodFor: block.
	from := block statements first.
	
	Clipboard clipboardText: '6'.
	from performAction: #pasteReplace.
	self assert: '6' equals: block statements first contents
]

{ #category : #'as yet unclassified' }
SBClipboardTest >> testPasteStringAfterCopyBlock [

	| block from to |
	block := '[5. 6]' parseAsSandblock.
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
