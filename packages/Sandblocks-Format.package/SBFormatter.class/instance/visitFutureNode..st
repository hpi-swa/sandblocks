as yet unclassified
visitFutureNode: aNode

	self flag: #fixme. " should probably investigate if this is an appropriate measure, consider the context and its arguments "
	self visitNode: aNode receiver.
	self assert: aNode futureArgs isEmpty.
	stream space; nextPutAll: aNode originalSelector; space; nextPutAll: aNode futureSelector