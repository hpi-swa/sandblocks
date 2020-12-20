as yet unclassified
visitReturnNode: aNode

	| node |
	node := self newNode: SBReturnNode.
	self connect: (aNode expr accept: self) outputSockets first to: (node inputSockets first).
	^ node