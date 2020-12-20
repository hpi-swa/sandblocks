accessing
focusAfterDeleteIfNone: aBlock

	| block |
	block := self valueOfProperty: #focusAfterDelete ifAbsent: aBlock.
	^ block isInWorld ifTrue: [block] ifFalse: [aBlock value]