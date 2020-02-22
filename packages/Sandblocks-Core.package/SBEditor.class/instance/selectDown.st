selection
selectDown

	| next from |
	from := self selection.
	
	" try to follow our steps back down "
	next := selectionDownHistory ifEmpty: [] ifNotEmpty: #removeLast.
	(self selection childSandblocks includes: next) ifFalse: [
		selectionDownHistory removeAll.
		next := self selection firstMorphThat: #isSandblock].
	
	next ifNotNil: [self select: next]