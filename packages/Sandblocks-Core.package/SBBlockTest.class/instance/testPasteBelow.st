as yet unclassified
testPasteBelow

	| block selection editor |
	block := '[a. b. c. self selected: 5]' parseAsSandblock.
	selection := block statements last.
	editor := self editorFor: block.
	(block statements viewFrom: 1 to: 3) do: #startOrAddToMultiSelection.
	block statements first
		select;
		copyToBuffer.
	selection pasteBelow.
	self assert: 'a' equals: block statements fifth contents.
	self assert: 'b' equals: block statements sixth contents.
	self assert: 'c' equals: block statements seventh contents