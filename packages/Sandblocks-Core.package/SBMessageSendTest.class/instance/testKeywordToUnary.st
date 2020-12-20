as yet unclassified
testKeywordToUnary

	| message |
	message := 'self assert: 5' parseAsSandblock.
	self editorFor: message.
	message select.
	message arguments first
		select;
		deleteBlock.
	self assert: message isUnary.
	self assert: 'assert' equals: message selector