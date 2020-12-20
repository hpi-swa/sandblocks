as yet unclassified
layoutCommands

	^ SBAlgebraCommand container
		morph: self;
		data: {
			self binding layoutCommands.
			SBAlgebraCommand gap.
			SBAlgebraCommand morph data: self submorphs second.
			SBAlgebraCommand indent data: {
				SBAlgebraCommand softLineOrGap.
				self expression layoutCommands}}