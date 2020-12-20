as yet unclassified
drawSubmorphsOn: aCanvas

	super drawSubmorphsOn: aCanvas.
	self actualReceiver ifNotNil: [:r | r guessedClass ifNotNil: [:class |
		(class canUnderstand: self selector asSymbol) ifFalse: [self drawFrame: Color yellow on: aCanvas]]]