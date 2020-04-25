as yet unclassified
layoutInset

	| space inset |
	space := self spaceForPrefix.
	inset := self colorPolicy layoutInset + super layoutInset.
	^ space > 0
		ifTrue: [inset isPoint
				ifTrue: [Rectangle left: space + inset x right: inset x top: inset y bottom: inset y]
				ifFalse: [Rectangle left: space + inset right: inset top: inset bottom: inset]]
		ifFalse: [inset]