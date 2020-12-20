as yet unclassified
layoutCommands

	^ SBAlgebraCommand container
		morph: self;
		data: (self receiver
			ifNil: [{self signature layoutCommands}]
			ifNotNil: [{
				self receiver layoutCommands.
				SBAlgebraCommand indent data: {
					SBAlgebraCommand softLineOrGap.
					self signature layoutCommands}}])