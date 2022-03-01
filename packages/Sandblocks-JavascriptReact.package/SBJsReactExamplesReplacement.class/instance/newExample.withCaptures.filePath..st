replacing
newExample: aJsObject withCaptures: aDictWithBlockCaptures filePath: aString

	| aJSArrayWithName exampleOptionsCopy |
	aJSArrayWithName := 'examples = [', aJsObject sourceString, ']'.
	self class
		generateHtmlFileForExample: aJsObject
		withCaptures: aDictWithBlockCaptures
		atFilePath: aString.
	exampleOptionsCopy := aJsObject buildCopy.
	
	^ SBColumn new
		addMorphBack: exampleOptionsCopy;
		addMorphBack: (SBJsReactMMBrowserWrapper new
			addMorphBack: (MMBrowserMorph reactOpenOn: (self class filePathToURL: aString));
			layoutInset: 8;
			changeTableLayout;
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap;
			yourself);
		addMorphBack: (self savePaletteButtonForExample: exampleOptionsCopy);
		borderWidth: 2;
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		yourself