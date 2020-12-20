as yet unclassified
deleteAfterCursor

	self cursor <= self contents size ifTrue: [
		self contents: (self contents first: self cursor - 1), (self contents allButFirst: self cursor)]