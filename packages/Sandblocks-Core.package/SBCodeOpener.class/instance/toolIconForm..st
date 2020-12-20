as yet unclassified
toolIconForm: aSymbolOrForm

	" there appears to be an API change here that we need to catch "
	^ aSymbolOrForm isForm ifTrue: [aSymbolOrForm] ifFalse: [ToolIcons  iconNamed:aSymbolOrForm]