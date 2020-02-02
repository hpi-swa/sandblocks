as yet unclassified
selectSubject: anObject

	self expressionIndex: (expressions keysInOrder findFirst: [:expression | expression subject = anObject])