updating
update: aSymbol with: anObject

	(aSymbol = #requestHandled) ifTrue: [
		self handleRequestTracking: anObject].