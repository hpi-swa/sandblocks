as yet unclassified
resizeToFit

	| extent outer |
	self fullBounds.
	outer := (self ownerThatIsA: SystemWindow) ifNil: [self].
	extent := scroll extentToFit + outer extent - scroll extent + (20 @ 20 * self scalingFactor).
	outer extent: extent x @ (extent y min: Display height - (100 * self scalingFactor))