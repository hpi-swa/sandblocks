*Sandblocks-Core
safeRepresentationThat: aSymbol do: aBlock ifNone: anotherBlock

	| options |
	options := self representationsThat: aSymbol.
	options size = 1 ifTrue: [^ aBlock value: (options first newFor: self)].
	options ifEmpty: [^ anotherBlock value].
	^ aBlock value: (self newFirstSafeOptionFrom: options)