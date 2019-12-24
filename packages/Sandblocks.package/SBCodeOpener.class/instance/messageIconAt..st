as yet unclassified
messageIconAt: aNumber

	^ ToolIcons
		iconForClass: (Smalltalk at: (self classes at: self selectedClassIndex))
		selector: (self methods at: aNumber)