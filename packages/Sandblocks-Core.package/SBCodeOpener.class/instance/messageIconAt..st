as yet unclassified
messageIconAt: aNumber

	^ self toolIconForm: (ToolIcons
		iconForClass: (Smalltalk at: (self classes at: self selectedClassIndex))
		selector: (self methods at: aNumber))