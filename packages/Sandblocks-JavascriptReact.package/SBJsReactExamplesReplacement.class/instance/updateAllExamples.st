replacing
updateAllExamples

	| captures |
	captures := self wrappedOwningClass allCaptures.
	self submorphs second submorphs withIndexDo: [:exampleTuple :index | | browser jsObject filePath |
		browser := exampleTuple submorphs second firstSubmorph.
		jsObject := exampleTuple firstSubmorph.
		filePath := self filePathForComponentName: (captures at: 'class_name') contents andIndex: index.
		self class generateHtmlFileForExample: jsObject withCaptures: captures atFilePath: filePath.
		browser doRefresh]