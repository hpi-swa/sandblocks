as yet unclassified
report: aValue for: aSymbol

	| reg watchers example |
	example := SBExecutionEnvironment value ifNil: [^ aValue].
	
	reg := self registry.
	watchers := reg at: aSymbol ifAbsent: [^ aValue].
	watchers do: [:watcher | watcher reportValue: aValue for: example].
	
	^ aValue