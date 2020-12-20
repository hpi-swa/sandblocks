as yet unclassified
testRotateBlock

	| block selection editor |
	block := '[a or: [b]]' parseAsSandblock.
	editor := self editorFor: block.
	selection := block statements first arguments first.
	selection leftRotate.
	self assert: block statements first isBlockBody.
	self assert: 'or:' equals: block statements first statements first selector.
	editor undo.
	self assert: 'or:' equals: block statements first selector.
	self assert: block statements first arguments first isBlockBody