as yet unclassified
minExtent

	| inset |
	inset := self layoutInset.
	^ super minExtent max: inset left + inset right @ (self fontToUse height + inset top + inset bottom)