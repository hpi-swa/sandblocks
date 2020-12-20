as yet unclassified
symbolsCheckStatement: aBlock for: aCollection

	((aBlock parentSandblock isMessageSend and: [aBlock isFirstChild not]) or:
		[aBlock isName and: [aBlock isMethodArgument]]) ifTrue: [
		^ {
			aCollection first ifNil: ['('] ifNotNil: ['(', aCollection first].
			aCollection second ifNil: [')'] ifNotNil: [aCollection second, ')']
		}].
	
	^ aBlock isStatement
		ifTrue: [
			aCollection last
				ifNil: [{aCollection first. self statementSeparator}]
				ifNotNil: [
					{aCollection first. (aCollection last, self statementSeparator)}]]
		ifFalse: [aCollection]