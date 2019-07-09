as yet unclassified
receiver: aBlock selector: aSymbol

	self assert: aSymbol isUnary.
	self receiver: aBlock selector: aSymbol arguments: #()