as yet unclassified
visitLiteralNode: aNode

	aNode key isString
		ifTrue: [(aNode key copy replaceAll: Character cr with: (Character value: 0)) storeOn: stream]
		ifFalse: [aNode key printAsLiteralOn: stream]