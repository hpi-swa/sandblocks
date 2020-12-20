as yet unclassified
tryDelete

	| editor p |
	p := self previousBlock.
	editor := self sandblockEditor.
	
	self deleteBlock.
	editor startInput: p at: 9e8 replacingContents: false