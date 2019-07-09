as yet unclassified
method: aMethodBlock

	| extent |
	self okToChange ifFalse: [^ self].
	
	methodContainer method: aMethodBlock.
	self resetState.
	self changed: #relabel.
	
	self fullBounds.
	
	extent := scroll extentToFit + self extent - scroll extent + (20 @ 20 * self scalingFactor).
	self extent: extent x @ (extent y min: Display height - (200 * self scalingFactor))