as yet unclassified
report: aValue for: aSymbol

	| reg watcher |
	reg := self registry.
	watcher := reg at: aSymbol ifAbsent: [^ aValue].
	(watcher isNil "or: [watcher isInWorld not]") ifTrue: [reg removeKey: aSymbol] ifFalse: [watcher reportValue: aValue].
	
	^ aValue