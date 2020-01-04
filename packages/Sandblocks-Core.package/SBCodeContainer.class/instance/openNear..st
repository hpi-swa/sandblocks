as yet unclassified
openNear: aBlock

	self position: aBlock codeContainer right + (5 * self scalingFactor) @ self top.
	aBlock sandblockEditor openMorph: self.
	self select