as yet unclassified
visitCascadeNode: aNode

	| messages receiver |
	receiver := aNode receiver accept: self.
	messages := aNode messages collect: [:node | (node accept: self) inCascade: true].
	
	messages overlappingPairsDo: [:source :target |
		self connect: source flowOutSocket to: target flowInSocket].
	
	^ messages last