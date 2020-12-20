as yet unclassified
parentThatAccepts: target ifNone: aBlock

	| adjacent |
	adjacent := self.
	[
		(adjacent parentSandblock ifNil: [^ aBlock value]) acceptChild: target] whileFalse: [adjacent := adjacent parentSandblock].
	^ adjacent