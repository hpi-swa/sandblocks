as yet unclassified
keyStroke: anEvent

	anEvent keyCharacter = Character escape ifTrue: [^ self delete].
	(anEvent keyCharacter = Character arrowRight or: [anEvent keyCharacter = $l and: [anEvent commandKeyPressed]]) ifTrue: [^ self focusPanel: currentPanelIndex + 1].
	(anEvent keyCharacter = Character arrowLeft or: [anEvent keyCharacter = $h and: [anEvent commandKeyPressed]]) ifTrue: [^ self focusPanel: currentPanelIndex - 1].
	anEvent keyCharacter = Character cr ifTrue: [result := self selectedClassOrMethod. ^ self delete].
	anEvent keyCharacter = Character tab ifTrue: [self showingClassSide: self showingClassSide not].
	(anEvent keyCharacter = $j and: [anEvent commandKeyPressed]) ifTrue: [^ self select: 1].
	(anEvent keyCharacter = $k and: [anEvent commandKeyPressed]) ifTrue: [^ self select: -1].
	((anEvent keyCharacter = $f or: [anEvent keyCharacter = $x]) and: [anEvent commandKeyPressed]) ifTrue: [^ self focus: UIManager default chooseClassOrTrait].
	self currentPanel keyStroke: anEvent