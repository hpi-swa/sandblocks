as yet unclassified
updateTempVariableValues

	| names |
	names := context tempNames.
	names withIndexDo: [:name :index | | value |
		value := context debuggerMap namedTempAt: index in: context.
		editor method blocksForVariableNamed: name do: [:block |
			blockValues at: block put: value]].
	self changed