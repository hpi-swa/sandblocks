selection
scrollToShow: aBlock

	(aBlock hasOwner: scroll) ifTrue: [
		scroll scrollToShow: aBlock]