as yet unclassified
wantsMultiRow: aMorph

	| width |
	aMorph submorphCount <= 1 ifTrue: [^ false].
	
	width := 0.
	aMorph submorphsDo: [:m |
		width := width + m minExtent x.
		width > (400 * aMorph scalingFactor) ifTrue: [^ true]].
	^ false