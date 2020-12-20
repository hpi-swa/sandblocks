as yet unclassified
layoutCommands

	^ SBAlgebraCommand container
		morph: self;
		data: {self firstSubmorph layoutCommands}