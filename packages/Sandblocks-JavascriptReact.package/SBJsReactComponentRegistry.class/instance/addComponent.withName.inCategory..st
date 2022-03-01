adding
addComponent: aSBJsReactJSXElementReplacement withName: aString inCategory: anotherString

	self componentRegistry
		at: anotherString
		ifPresent: [:entriesOfCategory | entriesOfCategory at: aString put: aSBJsReactJSXElementReplacement]
		ifAbsentPut: [
			Dictionary new
				at: aString put: aSBJsReactJSXElementReplacement;
				yourself]