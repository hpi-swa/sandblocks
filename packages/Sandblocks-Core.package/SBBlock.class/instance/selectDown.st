actions
selectDown
	<multiSelectAction>

	| next selectionDownHistory |
	selectionDownHistory := self sandblockEditor selectionDownHistory.
	
	" try to follow our steps back down "
	next := selectionDownHistory ifEmpty: [] ifNotEmpty: #removeLast.
	
	(self childSandblocks includes: next) ifFalse: [
		selectionDownHistory removeAll.
		next := self hasChildSandblocks ifTrue: [self childSandblocks first] ifFalse: [nil]].
	
	next
		ifNotNil: #select
		ifNil: [
			self sandblockEditor startInput: self at: 0 replacingContents: false]