printing
selectionLabel

	^ String streamContents: [:stream |
		self printOn: stream.
		
		self guessedClass ifNotNil: [:c | stream space; nextPut: $(. c printOn: stream. stream nextPut: $)]]