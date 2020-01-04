as yet unclassified
scrollToShow: aRectangle

	| r |
	r := aRectangle expandBy: self autoScrollMargin.
	r := Rectangle left: r left right: r right top: (0 max: r top) bottom: (r bottom min: self vTotalScrollRange).
	
	" if the elemnet is too large to feasibly be displayed, just opt out "
	self flag: #todo. " should at least make sure any part of it is visible "
	aRectangle height < scroller height ifFalse: [^ self].
	
	r top < scroller offset y
		ifTrue: [scroller offset: 0 @ r top]
		ifFalse: [
			r bottom > (scroller offset y + scroller height)
				ifTrue: [scroller offset: 0 @ (r bottom - scroller height)]
				ifFalse: [^ self]].
	self setScrollDeltas