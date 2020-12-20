as yet unclassified
classIconAt: anIndex

	^ self toolIconForm: (ToolIcons iconForClass: (Smalltalk at: (self classes at: anIndex)))