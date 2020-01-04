as yet unclassified
do

	oldSource := (method methodClass >> method currentSelector) getSourceFromFile.
	method methodClass removeSelector: method currentSelector.
	^ nil