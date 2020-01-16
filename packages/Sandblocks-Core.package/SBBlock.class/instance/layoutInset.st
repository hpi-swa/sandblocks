as yet unclassified
layoutInset

	| space |
	space := self spaceForPrefix.
	^ space > 0
		ifTrue: [ | inset |
			inset := super layoutInset.
			^ inset isPoint
				ifTrue: [Rectangle left: space + inset x right: inset x top: inset y bottom: inset y]
				ifFalse: [Rectangle left: space + inset right: inset top: inset bottom: inset]]
		ifFalse: [super layoutInset]