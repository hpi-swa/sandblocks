viewport
scrollToShow: aMorph
	
	| viewport x y target |
	viewport := 0 @ 0 extent: self extent.
	target := (aMorph boundsInWorld translateBy: (self topLeft) negated) expandBy: self scrollShowMargin.
	(viewport containsRect: target) ifTrue: [^ self].
	x := targetPosition x.
	y := targetPosition y.
	target right > viewport right
		ifTrue: [
			x := target right - viewport right + targetPosition x
					min: target left - viewport left + targetPosition x].
	target left < viewport left ifTrue: [x := target left - viewport left + targetPosition x].
	target bottom > viewport bottom
		ifTrue: [
			y := target bottom - viewport bottom + (self offset) y
					min: target top - viewport top + (self offset) y].
	target top < viewport top ifTrue: [y := target top - viewport top + targetPosition y].
	"self offset: x @ y"
	self animateToPosition: x @ y