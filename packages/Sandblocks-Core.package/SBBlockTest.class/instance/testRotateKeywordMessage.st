as yet unclassified
testRotateKeywordMessage

	| block selection editor |
	block := '[(a or: b) ifTrue: c]' parseAsSandblock.
	editor := self editorFor: block.
	selection := block statements first receiver.
	selection leftRotate.
	self assert: 'or:' equals: block statements first selector.
	self assert: 'a' equals: block statements first receiver contents.
	editor undo.
	self assert: 'ifTrue:' equals: block statements first selector.
	self assert: 'a' equals: block statements first receiver receiver contents