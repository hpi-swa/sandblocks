as yet unclassified
blocksForVariableNamed: aString do: aBlock

	self allBlocksDo: [:m | (m isBinding and: [m contents = aString]) ifTrue: [aBlock value: m]]