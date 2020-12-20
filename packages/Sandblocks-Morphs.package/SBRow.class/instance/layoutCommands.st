as yet unclassified
layoutCommands

	^ SBAlgebraCommand container
		morph: self;
		data: ((self submorphs select: #visible) collect: #layoutCommands separatedBy: [SBAlgebraCommand softLineOrGap])