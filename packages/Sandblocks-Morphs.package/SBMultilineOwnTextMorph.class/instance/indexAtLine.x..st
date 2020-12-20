as yet unclassified
indexAtLine: aNumber x: anotherNumber
	| line p |
	p := self paragraph.
	
	line := p lines at: (aNumber clampLow: 1 high: p numberOfLines).
	^ {((CharacterBlockScanner new text: p text textStyle: p textStyle)
		characterBlockAtPoint: (anotherNumber + self position x) @ line top index: nil in: line) stringIndex - 1. 0}