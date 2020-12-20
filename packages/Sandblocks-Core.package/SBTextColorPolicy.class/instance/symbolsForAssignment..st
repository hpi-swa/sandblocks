as yet unclassified
symbolsForAssignment: aBlock

	| parent |
	parent := aBlock parentSandblock.
	^ self symbolsCheckStatement: aBlock for: ((parent notNil and: [parent isMessageSend]) ifTrue: [#('(' ')')] ifFalse: [#(nil nil)])