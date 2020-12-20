as yet unclassified
updateSearch

	self contents ifEmpty: [^ self].
	(currentFocus isNil or: [(self matchesQuery: currentFocus) not]) ifTrue: [self nextResult]