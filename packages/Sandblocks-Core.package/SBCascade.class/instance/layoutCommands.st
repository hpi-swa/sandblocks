as yet unclassified
layoutCommands

	^ SBAlgebraCommand container
		morph: self;
		data: {
			self receiver layoutCommands.
			SBAlgebraCommand group data: (self messages gather: [:message | {SBAlgebraCommand hardLine withGap: true. message layoutCommands}])}