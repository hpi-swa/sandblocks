as yet unclassified
updateInsets

	self receiver
		ifNil: [ | inset |
			inset := self layoutInset.
			inset isRectangle ifFalse: [
				inset := inset asPoint.
				self layoutInset: (Rectangle left: 20 * self scalingFactor right: inset x top: inset y bottom: inset y)]]
		ifNotNil: [
			self layoutInset isRectangle ifTrue: [self layoutInset: self layoutInset right]]