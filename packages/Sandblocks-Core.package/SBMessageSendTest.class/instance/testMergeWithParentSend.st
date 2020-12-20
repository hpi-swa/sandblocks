as yet unclassified
testMergeWithParentSend

	| message |
	message := 'self assert: (5 equals: 6 more: 7)' parseAsSandblock.
	self editorFor: message.
	message arguments first
		select;
		mergeWithParentSend.
	self assert: message selector = 'assert:equals:more:'