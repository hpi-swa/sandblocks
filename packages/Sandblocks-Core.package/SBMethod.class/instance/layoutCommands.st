accessing
layoutCommands

	^ SBAlgebraCommand container
		morph: self;
		data: {
			SBAlgebraCommand container
				morph: self firstSubmorph;
				data: {
					self firstSubmorph submorphs first layoutCommands.
					SBAlgebraCommand indent data: {SBAlgebraCommand softLine. self firstSubmorph submorphs second layoutCommands}
				}
		}, (self body visible
			ifTrue: [{SBAlgebraCommand hardLine. self body layoutCommands}]
			ifFalse: [{}])