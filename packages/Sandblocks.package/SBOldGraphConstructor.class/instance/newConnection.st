as yet unclassified
newConnection

	| c |
	c := SBConnector new.
	graph addMorphBack: c.
	^ c