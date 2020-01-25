as yet unclassified
wantsMultiRow: aMorph

	| signatureExtent receiverExtent |
	signatureExtent := aMorph signature minExtent.
	receiverExtent := aMorph receiver minExtent.
	^ (signatureExtent x > (400 * aMorph scalingFactor) and: [receiverExtent x > 100 withScalingFactor])
		or: [receiverExtent x > (200 * aMorph scalingFactor) or: [signatureExtent y > (80 * aMorph scalingFactor)]]