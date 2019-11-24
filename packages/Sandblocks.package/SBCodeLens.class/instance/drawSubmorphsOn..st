as yet unclassified
drawSubmorphsOn: aCanvas

	| bottomOrigin fadeExtent fill |
	super drawSubmorphsOn: aCanvas.
	
	scroll visible ifFalse: [^ self].
	
	fadeExtent := scroll width @ self fadeSize.
	bottomOrigin := scroll bottomLeft - (0 @ self fadeSize).
	
	scroll offset y > 0 ifTrue: [
		fill := (GradientFillStyle ramp: {0.0 -> Color white. 0.3 -> (Color white alpha: 0.5). 1.0 -> (Color white alpha: 0.005)}) origin: scroll topLeft; direction: 0 @ self fadeSize.
		aCanvas fillRectangle: (scroll topLeft extent: fadeExtent) fillStyle: fill].
	
	scroll firstSubmorph height - scroll offset y - 30 > scroll height ifTrue: [
		fill := (GradientFillStyle ramp: {0.0 -> (Color white alpha: 0.005). 0.5 -> (Color white alpha: 0.5). 0.8 -> Color white}) origin: bottomOrigin; direction: 0 @ self fadeSize.
		aCanvas fillRectangle: (bottomOrigin extent: fadeExtent) fillStyle: fill]