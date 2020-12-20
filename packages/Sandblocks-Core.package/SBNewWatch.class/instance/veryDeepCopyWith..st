as yet unclassified
veryDeepCopyWith: deepCopier

	" assure that copies of us have a unique id "
	| new oldDisplay |
	oldDisplay := display.
	display := SBNewWatchView new.
	oldDisplay replaceBy: display.
	
	new := super veryDeepCopyWith: deepCopier.
	new newIdentifier.
	
	display replaceBy: oldDisplay.
	display := oldDisplay.
	
	^ new