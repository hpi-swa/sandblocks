as yet unclassified
keyStroke: anEvent

	anEvent keyCharacter = Character escape ifTrue: [^ self delete].
	anEvent keyCharacter = Character arrowRight ifTrue: [^ self focusPanel: currentPanelIndex + 1].
	anEvent keyCharacter = Character arrowLeft ifTrue: [^ self focusPanel: currentPanelIndex - 1].
	anEvent keyCharacter = Character cr ifTrue: [result := self selectedClassOrMethod. ^ self delete].
	anEvent keyCharacter = Character tab ifTrue: [self showingClassSide: self showingClassSide not].
	(anEvent keyCharacter = $f and: [anEvent commandKeyPressed]) ifTrue: [^ self focus: UIManager default chooseClassOrTrait].
	self currentPanel keyStroke: anEvent