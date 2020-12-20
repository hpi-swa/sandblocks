as yet unclassified
testDeleteAround

	| block |
	block := '[5 yourself: 2 send: 8]' parseAsSandblock.
	self editorFor: block.
	
	block statements first messageParts second deleteAround.
	self assert: block statements first contents = 'send'