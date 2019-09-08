as yet unclassified
visitBlockNode: aNode

	| node current |
	node := self newNode: SBFlowSourceNode.
	
	current := node.
	aNode statements do: [:stmt | | next |
		next := stmt accept: self.
		self connect: current flowOutSocket to: next flowInSocket.
		current := next].
	
	^ node