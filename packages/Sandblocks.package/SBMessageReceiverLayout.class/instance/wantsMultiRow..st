as yet unclassified
wantsMultiRow: aMorph

	^ aMorph signature minExtent x > (400 * aMorph scalingFactor) or:
		[aMorph receiver minExtent x > (200 * aMorph scalingFactor)]