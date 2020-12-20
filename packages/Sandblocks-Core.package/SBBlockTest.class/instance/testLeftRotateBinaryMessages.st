as yet unclassified
testLeftRotateBinaryMessages

	| block selection editor |
	block := '[(a + b) * c]' parseAsSandblock.
	editor := self editorFor: block.
	selection := block statements first receiver.
	selection leftRotate.
	self assert: block statements first selector = '+'.
	self assert: block statements first receiver contents = 'a'.
	editor undo.
	self assert: block statements first selector = '*'.
	self assert: block statements first receiver receiver contents = 'a'