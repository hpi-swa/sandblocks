viewport
scrollToShow: aMorph

	| viewport x y target c |
	viewport := 0 @ 0 extent: self extent.
	target := (aMorph boundsInWorld translateBy: self topLeft negated) expandBy: self scrollShowMargin.
	(viewport containsRect: target) ifTrue: [
		self viewportPosition: self currentPosition.
		^ self].
	
	c := self currentPosition.
	x := c x.
	y := c y.
	target right > viewport right ifTrue: [
		x := (target right - viewport right) + c x min: (target left - viewport left) + c x].
	target left < viewport left ifTrue: [
		x := (target left - viewport left) + c x].
	target bottom > viewport bottom ifTrue: [
		y := (target bottom - viewport bottom) + c y min: (target top - viewport top) + c y].
	target top < viewport top ifTrue: [
		y := (target top - viewport top) + c y].
	
	self animateToPosition: x @ y