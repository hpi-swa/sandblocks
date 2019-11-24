colors
extent: aPoint

	super extent: (TextStyle defaultFont height asPoint * (size caseOf: {
		[#large] -> [1.2].
		[#small] -> [2/3].
		[#regular] ->  [1].
	})) rounded