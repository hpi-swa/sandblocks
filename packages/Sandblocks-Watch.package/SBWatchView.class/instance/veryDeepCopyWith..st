as yet unclassified
veryDeepCopyWith: deepCopier

	| new oldLastValue |
	oldLastValue := lastValue.
	lastValue := nil.
	
	new := super veryDeepCopyWith: deepCopier.
	lastValue := oldLastValue.
	
	^ new