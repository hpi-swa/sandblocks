as yet unclassified
testMatchesEscape

	self assert: (Character escape asSandblockShortcut matchesEvent: (KeyboardEvent new setType: #keyDown buttons: 0 position: 0 @ 0 keyValue: Character escape asInteger hand: nil stamp: 0))