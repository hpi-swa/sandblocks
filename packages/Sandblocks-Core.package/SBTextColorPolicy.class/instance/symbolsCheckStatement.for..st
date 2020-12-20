as yet unclassified
symbolsCheckStatement: aBlock for: aCollection

	^ (aBlock isStatement and: [aBlock isLastChild not])
		ifTrue: [
			aCollection last
				ifNil: [{aCollection first. self statementSeparator}]
				ifNotNil: [
					{aCollection first. (aCollection last, self statementSeparator)}]]
		ifFalse: [aCollection]