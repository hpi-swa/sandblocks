as yet unclassified
focusPanel: aNumber

	currentPanelIndex := aNumber clampLow: 1 high: self submorphCount.
	(currentPanelIndex = 2 and: [self selectedClassIndex = 0]) ifTrue: [self selectedClassIndex: 1].
	currentPanelIndex < 2 ifTrue: [self selectedClassIndex: 0].
	
	(currentPanelIndex = 3 and: [self selectedMethodIndex = 0]) ifTrue: [self selectedMethodIndex: 1].
	currentPanelIndex < 3 ifTrue: [self selectedMethodIndex: 0]