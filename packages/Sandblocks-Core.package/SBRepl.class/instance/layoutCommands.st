as yet unclassified
layoutCommands

	^ SBAlgebraCommand container
		morph: self;
		data: {
			SBAlgebraCommand morph data: self firstSubmorph.
			SBAlgebraCommand hardLine withGap: true.
			self lastSubmorph layoutCommands}