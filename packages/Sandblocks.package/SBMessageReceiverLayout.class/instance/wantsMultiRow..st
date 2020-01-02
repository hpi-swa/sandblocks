as yet unclassified
wantsMultiRow: aMorph

	| signatureExtent |
	signatureExtent := aMorph signature minExtent.
	^ signatureExtent x > (400 * aMorph scalingFactor) or:
		[aMorph receiver minExtent x > (200 * aMorph scalingFactor)  or:
		[signatureExtent y > (80 * aMorph scalingFactor)]]