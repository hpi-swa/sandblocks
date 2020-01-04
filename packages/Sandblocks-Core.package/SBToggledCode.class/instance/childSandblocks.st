as yet unclassified
childSandblocks

	| config |
	config := self firstSubmorph submorphs.
	self submorphCount > 1 ifTrue: [config := config copyWith: self lastSubmorph].
	^ config