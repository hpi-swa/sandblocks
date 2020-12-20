as yet unclassified
nextVerticalNear: aNumber

	| allCandidates candidates candidatesBestDistance tolerance |
	^ self
		nextVerticalNear: aNumber
		calcDistance: [:candidate | candidate top - self bottom]
		validBlock: [:candidate | candidate top > self bottom]