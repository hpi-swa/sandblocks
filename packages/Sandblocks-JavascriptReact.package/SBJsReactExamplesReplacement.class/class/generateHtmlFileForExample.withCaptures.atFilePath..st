generate-html
generateHtmlFileForExample: aJsObject withCaptures: aDictWithBlockCaptures atFilePath: aString

	| htmlString |
	htmlString := self exampleHTMLTemplateForExample: aJsObject withCaptures: aDictWithBlockCaptures.
	FileStream forceNewFileNamed: aString do: [:stream | stream nextPutAll: htmlString]