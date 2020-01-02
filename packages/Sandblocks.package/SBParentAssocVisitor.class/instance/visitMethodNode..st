as yet unclassified
visitMethodNode: aNode 
	parents at: aNode body put: aNode.
	super visitMethodNode: aNode