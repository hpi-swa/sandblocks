as yet unclassified
drawString: aString on: aCanvas at: aPoint font: aFont color: aColor

	SBColorPolicy usePango
		ifTrue: [
			PHPangoTextLayout new
				font: '6';
				text: aString;
				
				fullDrawOn: aCanvas
				transform: (MatrixTransform2x3 withOffset: self extent / 2 + self layoutBounds origin + aCanvas origin)
				color: aColor
				selectionColor: nil
				selectionFillColor: nil
				clip: (aCanvas clipRect translateBy: aCanvas origin)
				drawCursor: false
				finalPosition: self layoutBounds topLeft]
		ifFalse: [aCanvas drawString: aString at: aPoint font: aFont color: aColor]