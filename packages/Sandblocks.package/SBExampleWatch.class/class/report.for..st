as yet unclassified
report: aValue for: aSymbol

	| reg watcher |
	SBExample allInstances
		detect: #isCurrent
		ifFound: [:example |
			reg := self registry.
			watcher := reg at: aSymbol ifAbsent: [^ aValue].
			watcher ifNil: [reg removeKey: aSymbol] ifNotNil: [watcher reportValue: aValue]]
		ifNone: [].
	
	^ aValue