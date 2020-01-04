as yet unclassified
layoutInset

	| space |
	space := self spaceForPrefix.
	^ space > 0
		ifTrue: [ | inset |
			inset := super layoutInset isPoint ifTrue: [super layoutInset x] ifFalse: [super layoutInset].
			^ Rectangle left: space + inset right: inset top: inset bottom: inset]
		ifFalse: [super layoutInset]