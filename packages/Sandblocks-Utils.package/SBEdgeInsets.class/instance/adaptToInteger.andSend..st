as yet unclassified
adaptToInteger: aNumber andSend: aSymbol

	self flag: #todo.
	self assert: aSymbol = #+.
	^ aNumber adaptToEdgeInsetsAndAdd: self