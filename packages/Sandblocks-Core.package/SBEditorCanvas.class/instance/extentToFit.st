accessing
extentToFit

	| full |
	full := self submorphBounds.
	^ full extent + ((full origin max: 0 @ 0) - self position)