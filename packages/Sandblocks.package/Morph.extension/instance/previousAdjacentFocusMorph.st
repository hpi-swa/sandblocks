*Sandblocks
previousAdjacentFocusMorph

	| next |
	next := self.
	[
	next := next submorphBefore.
	next  ifNil: [^ nil].
	next lastMorphThatWantsFocus ifNotNil: [:m | ^ m]] repeat