as yet unclassified
receiver: aBlock

	self submorphCount > 1 ifTrue: [self firstSubmorph delete].
	aBlock
		ifNil: [ | inset |
			inset := self layoutInset.
			self layoutInset: (Rectangle left: 20 * self scalingFactor right: inset top: inset bottom: inset)] 		ifNotNil: [
			self layoutInset isRectangle ifTrue: [self layoutInset: self layoutInset right].
			self addMorph: aBlock]