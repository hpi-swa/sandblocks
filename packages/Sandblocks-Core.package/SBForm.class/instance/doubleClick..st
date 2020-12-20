as yet unclassified
doubleClick: anEvent

	(UIManager default chooseFileMatching: '*') ifNotNil: [:f | self filename: f]