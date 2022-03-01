accessing
generatedHTMLFileDir
	<preference: 'Html File Temp Folder' category: 'Sandblocks-JavascriptReact' description: 'Set the directory for the generated html files for magic mouse.' type: #String>

	^ GeneratedHTMLFileDir ifNil: ['~/Desktop/']