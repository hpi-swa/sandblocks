as yet unclassified
scrollToShow: aRectangle

	| r |
	r := aRectangle expandBy: self autoScrollMargin.
	r := Rectangle left: r left right: r right top: (0 max: r top) bottom: (r bottom min: self vTotalScrollRange).
	
	r top <= scroller offset y
		ifTrue: [scroller offset: 0 @ r top]
		ifFalse: [
			r bottom > (scroller offset y + scroller height)
				ifTrue: [scroller offset: 0 @ (r bottom - scroller height)]
				ifFalse: [^ self]].
	self setScrollDeltas