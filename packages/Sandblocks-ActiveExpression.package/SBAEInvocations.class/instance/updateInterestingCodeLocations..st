helper
updateInterestingCodeLocations: aCollection

	" walk up from each tracked invocation and find the first point where all differ "
	| index |
	aCollection size < 2 ifTrue: [^ self].
	
	index := 1.
	[ 
		((aCollection anySatisfy: [:invocation | invocation stack size >= index]) or: [(aCollection collect: [:invocation | invocation stack at: index] as: Set) size > 1]) ifTrue: [
			aCollection do: [:invocation | invocation stackImageIndex: index].
			^ self].
		index := index + 1
	] repeat