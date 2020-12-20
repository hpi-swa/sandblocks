as yet unclassified
applyMappingFor: aMethodNode

	self
		buildNodeMapFor: aMethodNode
		do: [:nodeMap :generated |
			aMethodNode accept: (ParseNodeEnumerator ofBlock: [:node | | generatedNode |
				generatedNode := nodeMap at: node.
				node pc: generatedNode pc.
				node isBlockNode ifTrue: [
					node closureCreationNode: generatedNode closureCreationNode]])].
	^ aMethodNode