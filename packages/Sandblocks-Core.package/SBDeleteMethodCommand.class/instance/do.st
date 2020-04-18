as yet unclassified
do

	oldSource := (target currentClass >> target currentSelector) getSourceFromFile.
	target currentClass removeSelector: target currentSelector.
	^ super do