as yet unclassified
layoutCommands

	^ SBAlgebraCommand container
		morph: self;
		"data: (Array streamContents: [:str |
			self submorphs withIndexDo: [:morph :index |
				str nextPut: morph layoutCommands.
				(index \\ 2 = 1 and: [index > 1]) ifTrue: [str nextPut: SBAlgebraCommand softLineOrGap]]]);"
		data: (self submorphs pairsCollect: [:a :b | SBAlgebraCommand group data: {a layoutCommands. SBAlgebraCommand gap. b layoutCommands. SBAlgebraCommand softLineOrGap}]), {self lastSubmorph layoutCommands}