as yet unclassified
do

	| ret |
	ret := super do.
	oldSource := (target currentClass >> target currentSelector) getSourceFromFile.
	category := (target currentClass >> target currentSelector) methodClass category.
	target currentClass removeSelector: target currentSelector.
	^ ret