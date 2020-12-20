updating
update: aSymbol

	(aSymbol = #lastRequest) ifTrue: [
		self firstSubmorph contents: 'total requests: ', requestLog size.
		self lastSubmorph label: 'last request: "', self lastRequest statusString, '"'].