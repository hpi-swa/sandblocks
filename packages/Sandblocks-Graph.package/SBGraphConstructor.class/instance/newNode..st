as yet unclassified
newNode: aClass

	| node |
	node := aClass new.
	graph addMorphBack: node.
	^ node