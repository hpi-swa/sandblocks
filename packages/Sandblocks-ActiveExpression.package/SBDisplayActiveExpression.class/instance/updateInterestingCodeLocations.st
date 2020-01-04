as yet unclassified
updateInterestingCodeLocations

	" walk up from each tracked invocation and find the first point where all differ "
	| index |
	self submorphCount < 2 ifTrue: [^ self].
	
	index := 1.
	[ | difference |
		difference := self submorphs collect: [:invocation | invocation stack at: index] as: Set.
		difference size > 1 ifTrue: [
			self submorphs do: [:invocation | invocation stackImageIndex: index].
			^ self].
		index := index + 1
	] repeat