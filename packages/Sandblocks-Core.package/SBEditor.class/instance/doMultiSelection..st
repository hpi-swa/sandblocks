actions
doMultiSelection: aBlock

	| command |
	command := aBlock value: self sortedMultiSelection.
	(command notNil and: [command valid]) ifTrue: [
		self do: command.
		(mode = #selection or: [mode = #continuousSelection]) ifTrue: [self endMultiSelection]]