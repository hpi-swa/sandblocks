event handling
resetParentHighlights

	self allOwnersDo: [:m |
		(m valueOfProperty: #highlightedForDrop ifAbsent: [false]) ifTrue: [m resetHighlightForDrop]]