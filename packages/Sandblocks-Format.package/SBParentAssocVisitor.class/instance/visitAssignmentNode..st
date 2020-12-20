as yet unclassified
visitAssignmentNode: aNode

	parents at: aNode value put: aNode.
	parents at: aNode variable put: aNode.
	super visitAssignmentNode: aNode