as yet unclassified
mouseDown: anEvent

	| block |
	block := self paragraph characterBlockAtPoint: anEvent position.
	self paragraph selectionStart: block selectionStop: block.
	self moveCursorTo: block stringIndex