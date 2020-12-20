as yet unclassified
updateCursor

	| bounds p |
	bounds := self selectionBounds.
	p := self paragraph.
	
	p
		selectionStart: (p characterBlockForIndex: bounds first)
		selectionStop: (p characterBlockForIndex: bounds second).
	p showCaret: bounds first > 0.
	
	self triggerEvent: #selectionChanged