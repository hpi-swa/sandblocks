as yet unclassified
minimumHeight

	| inset |
	inset := self layoutInset.
	^ (self fontToUse height + inset top + inset bottom)