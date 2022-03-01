replacing
addNewEmptyExample

	| newExample defaultExampleObject exampleCount filePath |
	exampleCount := self allExamples size.
	defaultExampleObject := SBJavascript parseElement: '{componentProps:{}}'.
	filePath := self filePathForIndex: exampleCount + 1.
	newExample := self
		newExample: defaultExampleObject
		withCaptures: self wrappedOwningClass allCaptures
		filePath: filePath.
	self submorphs second addMorphBack: newExample