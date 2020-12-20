as yet unclassified
veryDeepCopyWith: aCopier

	| new previousBinding |
	previousBinding := binding.
	new := super veryDeepCopyWith: aCopier.
	binding := previousBinding.
	new binding: previousBinding.
	^ new