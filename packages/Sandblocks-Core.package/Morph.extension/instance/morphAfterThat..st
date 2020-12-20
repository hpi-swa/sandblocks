*Sandblocks-Core
morphAfterThat: aBlock

	| next |
	next  := self.
	[
	next := next submorphAfter.
	next  ifNil: [^ nil].
	(aBlock value: next) ifTrue: [^ next]] repeat