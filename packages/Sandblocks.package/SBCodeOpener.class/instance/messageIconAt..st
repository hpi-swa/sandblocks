as yet unclassified
messageIconAt: aNumber

	^ ToolIcons iconNamed: (ToolIcons
		iconForClass: (Smalltalk at: (self classes at: self selectedClassIndex))
		selector: (self methods at: aNumber))