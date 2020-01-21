as yet unclassified
visitBraceNode: aNode

	| node current |
	node := self newNode: SBArraySourceNode.
	
	current := node.
	aNode elements do: [:stmt | | next |
		next := stmt accept: self.
		self connect: current flowOutSocket to: next flowInSocket.
		current := next].
	
	^ node