*Sandblocks-Core
representationThat: aSymbol do: aBlock ifNone: anotherBlock

	| options index representation |
	options := self representationsThat: aSymbol.
	options size = 1 ifTrue: [^ aBlock value: (options first newFor: self)].
	options ifEmpty: [^ anotherBlock value].
	index := UIManager default
		chooseFrom: (options collect: [:repr | repr prettyName])
		title: ('How to represent {1} ({2})' format: {self asString. self className}).
	index = 0 ifTrue: [^ anotherBlock value].
	representation := (options at: index) newFor: self.
	^ aBlock value: representation