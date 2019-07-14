as yet unclassified
updateInsets

	self receiver
		ifNil: [ | inset |
			inset := self layoutInset.
			inset isRectangle ifFalse: [self layoutInset: (Rectangle left: 20 * self scalingFactor right: inset top: inset bottom: inset)]]
		ifNotNil: [
			self layoutInset isRectangle ifTrue: [self layoutInset: self layoutInset right]]