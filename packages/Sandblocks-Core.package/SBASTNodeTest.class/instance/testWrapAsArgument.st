as yet unclassified
testWrapAsArgument

	| block selection |
	block := '[5]' parseAsSandblock.
	self editorFor: block.
	selection := block statements first.
	selection wrapAsArgument.
	self assert: block statements first isMessageSend.
	self assert: block statements first arguments first = selection.
	self assert: block statements first receiver isUnknown