as yet unclassified
willBeMultiLine: aNode

	| text |
	text := self preFormat: aNode.
	^ (text includes: Character cr) or: [text size > 50]