replacing
filePathForComponentName: aComponentNameString andIndex: index

	^ self class generatedHTMLFileDir, 'Component_', aComponentNameString, '_', index asString, '.html'