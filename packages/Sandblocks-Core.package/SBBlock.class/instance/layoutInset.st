as yet unclassified
layoutInset

	| space inset |
	space := self spaceForSymbols.
	inset := (self colorPolicy layoutInsetFor: self) + super layoutInset.
	^ (space first > 0 or: [space second > 0])
		ifTrue: [inset isPoint
				ifTrue: [SBEdgeInsets left: space first + inset x right: inset x + space second top: inset y bottom: inset y]
				ifFalse: [SBEdgeInsets left: space first + inset right: inset + space second top: inset bottom: inset]]
		ifFalse: [inset]