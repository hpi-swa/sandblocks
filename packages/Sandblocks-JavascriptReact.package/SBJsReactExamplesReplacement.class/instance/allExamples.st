accessing
allExamples

	^ self submorphs second submorphs collect: [:submorph | submorph firstSubmorph]