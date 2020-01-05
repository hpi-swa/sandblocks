as yet unclassified
isMultiLineMessage: aNode

	^ aNode arguments size > 1 and: [(aNode originalSelector size + (aNode originalArguments inject: 0 into: [:sum :arg | sum + (self preFormat: arg) size])) > self maxLineLength]