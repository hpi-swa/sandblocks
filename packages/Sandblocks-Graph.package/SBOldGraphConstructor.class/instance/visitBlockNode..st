as yet unclassified
visitBlockNode: aNode

	| node current |
	node := self newNode.
	
	node addOutput: '['.
	node hasFlowOut: true.
	
	current := node.
	aNode statements do: [:stmt | | next |
		next := stmt accept: self.
		next hasFlowOut: true; hasFlowIn: true.
		self connect: current flowOut to: next flowIn.
		current := next].
	
	^ node