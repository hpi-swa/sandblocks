as yet unclassified
adaptToPoint: aPoint andSend: aSymbol

	self flag: #todo.
	self assert: aSymbol = #+.
	^ aPoint + (self horizontal @ self vertical)