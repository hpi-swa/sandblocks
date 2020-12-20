as yet unclassified
symbolsForMessageSend: aBlock

	| parent |
	parent := aBlock parentSandblock.
	parent ifNil: [^ self symbolsCheckStatement: aBlock for: #(nil nil)].
	
	(parent isCascade and: [aBlock ~= parent lastSubmorph]) ifTrue: [
		^ self
			symbolsCheckStatement: aBlock
			for: (aBlock = parent firstSubmorph ifTrue: [
				aBlock precedence > 1 ifTrue: [#('(' ')')] ifFalse: [#(nil nil)]] ifFalse: [#(nil ';')])].
	
	^ self
		symbolsCheckStatement: aBlock
		for: ((parent isMessageSend and: [
			aBlock precedence > parent precedence or: [parent precedence = 3 and: [aBlock precedence = 3]]]) ifTrue: [#('(' ')')] ifFalse: [#(nil nil)])