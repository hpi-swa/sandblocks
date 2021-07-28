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
