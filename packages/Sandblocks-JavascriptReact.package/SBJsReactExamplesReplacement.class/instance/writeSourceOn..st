saving
writeSourceOn: aStream

	aStream
		nextPutAll: 'examples = [';
		nextPutAll: ((self allExamples collect: [:jsObject | jsObject sourceString]) joinSeparatedBy: ',');
		nextPutAll: ']'