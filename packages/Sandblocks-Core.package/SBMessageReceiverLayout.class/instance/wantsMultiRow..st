as yet unclassified
wantsMultiRow: aMorph

	| signatureExtent receiverExtent |
	signatureExtent := aMorph signature minExtent.
	receiverExtent := aMorph receiver minExtent.
	^ (signatureExtent x > (400 withScalingFactor) and: [receiverExtent x > 100 withScalingFactor])
		or: [(signatureExtent x > 100 and: [receiverExtent x > (200 withScalingFactor)])
		or: [signatureExtent y > (80 * aMorph scalingFactor)]]