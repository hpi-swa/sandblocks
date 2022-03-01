screenshot-taking
takeScreenshotOf: aSBJsReactComponentWrapper withExample: aJsObject withExtent: aPoint

	| tabId filePath screenshot instance |
	instance := self new.
	filePath := SBJsReactExamplesReplacement generatedHTMLFileDir, 'Screenshot_temp.html'.
	SBJsReactExamplesReplacement
		generateHtmlFileForExample: aJsObject
		withCaptures: aSBJsReactComponentWrapper allCaptures
		atFilePath: filePath.
	tabId := MMProcessWrapper getOSDependentSingleton
		takeScreenshotAt: (SBJsReactExamplesReplacement filePathToURL: filePath)
		withExtend: aPoint
		for: instance.
	screenshot := instance waitAndGetScreenshot.
	MMProcessWrapper getOSDependentSingleton closeTab: tabId.
	screenshot := screenshot trimBordersOfColor: Color white.
	^ screenshot