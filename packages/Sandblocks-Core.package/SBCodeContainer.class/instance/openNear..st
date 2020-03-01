initialization
openNear: aBlock

	aBlock sandblockEditor openMorphInView: self.
	self position: aBlock containingArtefact right + (5 * self scalingFactor) @ self top.
	self select