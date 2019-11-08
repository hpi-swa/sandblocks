as yet unclassified
report: aValue for: aSymbol

	| reg watcher |
	reg := self registry.
	watcher := reg at: aSymbol ifAbsent: [^ aValue].
	watcher ifNil: [reg removeKey: aSymbol] ifNotNil: [watcher reportValue: aValue].
	
	^ aValue