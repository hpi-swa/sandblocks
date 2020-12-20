as yet unclassified
veryDeepCopyWith: deepCopier

	" assure that copies of us have a unique id "
	| new oldExamplesValues |
	oldExamplesValues := exampleValues.
	exampleValues := Dictionary new.
	
	new := super veryDeepCopyWith: deepCopier.
	exampleValues := oldExamplesValues.
	new newIdentifier.
	^ new