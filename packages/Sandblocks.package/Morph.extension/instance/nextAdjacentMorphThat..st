*Sandblocks
nextAdjacentMorphThat: aBlock

	| next |
	next  := self.
	[
	next := next submorphAfter.
	next  ifNil: [^ nil].
	(next firstMorphThat: aBlock) ifNotNil: [:m | ^ m]] repeat