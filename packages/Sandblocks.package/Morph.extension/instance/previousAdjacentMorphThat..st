*Sandblocks
previousAdjacentMorphThat: aBlock

	| next |
	next := self.
	[
	next := next submorphBefore.
	next  ifNil: [^ nil].
	(next lastMorphThat: aBlock) ifNotNil: [:m | ^ m]] repeat