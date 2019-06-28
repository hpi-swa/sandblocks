*Sandblocks
nextAdjacentFocusMorph

	| next |
	next  := self.
	[
	next := next submorphAfter.
	next  ifNil: [^ nil].
	next firstMorphThatWantsFocus ifNotNil: [:m | ^ m]] repeat