as yet unclassified
testWrapInMessageSend

	| block selection |
	block := '[5]' parseAsSandblock.
	selection := block statements first.
	self editorFor: block.
	selection wrapInMessageSend: 'hello'.
	self assert: block statements first isMessageSend.
	self assert: block statements first selector = 'hello'.
	self assert: block statements first receiver = selection