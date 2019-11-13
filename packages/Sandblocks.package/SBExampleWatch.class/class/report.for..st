as yet unclassified
report: aValue for: aSymbol

	| reg watcher example |
	example  := SBExample allInstances
		detect: #isCurrent
		ifNone: [nil].
	
	reg := self registry.
	watcher := reg at: aSymbol ifAbsent: [^ aValue].
	watcher ifNil: [reg removeKey: aSymbol] ifNotNil: [watcher reportValue: aValue for: example].
	
	^ aValue