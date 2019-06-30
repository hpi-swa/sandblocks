*Sandblocks
morphBeforeThat: aBlock

	| next |
	next  := self.
	[
	next := next submorphBefore.
	next  ifNil: [^ nil].
	(aBlock value: next) ifTrue: [^ next]] repeat