as yet unclassified
visitLiteralVariableNode: aNode

	^ (self newNode: SBLiteralNode) name: aNode name; yourself