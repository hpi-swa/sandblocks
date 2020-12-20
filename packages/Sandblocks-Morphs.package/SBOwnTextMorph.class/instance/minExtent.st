as yet unclassified
minExtent

	| font |
	font := self fontToUse.
	^ (font widthOfString: self contents) @ font height max: 4 withScalingFactor @ font height