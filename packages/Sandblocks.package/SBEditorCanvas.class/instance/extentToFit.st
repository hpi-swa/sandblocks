as yet unclassified
extentToFit

	| full |
	full := Rectangle merging: self submorphs.
	^ full extent + ((full origin max: 0 @ 0) - self position)