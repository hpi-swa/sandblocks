as yet unclassified
isMultiLineMessage: aNode 
	^ aNode originalSelector size
		+ (aNode arguments
				inject: 0
				into: [:sum :arg | sum + (self preFormat: arg) size]) > self maxLineLength