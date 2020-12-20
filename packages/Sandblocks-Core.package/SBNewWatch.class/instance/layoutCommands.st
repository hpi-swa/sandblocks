as yet unclassified
layoutCommands

	^ SBAlgebraCommand container
		morph: self;
		data: {
			self submorphs first layoutCommands.
			SBAlgebraCommand hardLine.
			SBAlgebraCommand morph data: self submorphs second}