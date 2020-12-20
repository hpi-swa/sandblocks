as yet unclassified
layoutCommands

	^ SBAlgebraCommand container
		morph: self;
		data: (self isUnary
			ifTrue: [{self firstSubmorph layoutCommands}]
			ifFalse: [
				(Array new: self submorphCount streamContents: [:stream |
					self submorphs pairsDo: [:messagePart :argument |
						stream nextPut: (SBAlgebraCommand indent data: {messagePart layoutCommands. SBAlgebraCommand softLineOrGap. argument layoutCommands}).
						argument ~= self lastSubmorph ifTrue: [stream nextPut: SBAlgebraCommand softLineOrGap]]])])