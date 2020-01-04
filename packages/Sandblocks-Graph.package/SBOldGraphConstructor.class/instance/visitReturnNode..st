as yet unclassified
visitReturnNode: aNode

	| node |
	node := self newNode.
	self connect: (aNode expr accept: self) output to: (node addInput: '^').
	^ node