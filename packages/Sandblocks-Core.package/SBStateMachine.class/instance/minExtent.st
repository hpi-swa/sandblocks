as yet unclassified
minExtent

	| area |
	area := Rectangle merging: self submorphs.
	^ area extent + (area origin - self position)