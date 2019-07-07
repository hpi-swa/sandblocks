selection
multiSelection

	^ mode = #selection
		ifTrue: [multiSelection]
		ifFalse: [self selection ifNotNil: [{self selection}] ifNil: [#()]]
	"^ multiSelection ifEmpty: [self selection ifNotNil: [{self selection}] ifNil: [#()]]"