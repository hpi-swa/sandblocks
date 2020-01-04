as yet unclassified
visitLiteralNode: aNode

	^ (self newNode: SBLiteralNode) name: aNode key asString; yourself