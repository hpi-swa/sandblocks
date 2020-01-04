as yet unclassified
veryDeepCopyWith: deepCopier

	" assure that copies of us have a unique id "
	| new |
	new := super veryDeepCopyWith: deepCopier.
	new newIdentifier.
	^ new