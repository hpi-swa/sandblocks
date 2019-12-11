as yet unclassified
scrollToShow: aMorph
	
	| viewport x y target |
	viewport := 0 @ 0 extent: self extent.
	target := (aMorph boundsInWorld translateBy: (self topLeft) negated) expandBy: self scrollShowMargin.
	(viewport containsRect: target) ifTrue: [^ self].
	x := (self offset) x.
	y := (self offset) y.
	target right > viewport right
		ifTrue: [
			x := target right - viewport right + (self offset) x
					min: target left - viewport left + (self offset) x].
	target left < viewport left ifTrue: [x := target left - viewport left + (self offset) x].
	target bottom > viewport bottom
		ifTrue: [
			y := target bottom - viewport bottom + (self offset) y
					min: target top - viewport top + (self offset) y].
	target top < viewport top ifTrue: [y := target top - viewport top + (self offset) y].
	self offset: x @ y