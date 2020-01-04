as yet unclassified
deleteBeforeCursor

	self cursor <= 1 ifTrue: [^ self].
	
	self cursor = (self contents size + 1) ifTrue: [
		self contents: self contents allButLast.
		^ self].
	
	self contents: (self contents first: self cursor - 2), (self contents allButFirst: self cursor - 1).
	self moveCursorTo: self cursor - 1