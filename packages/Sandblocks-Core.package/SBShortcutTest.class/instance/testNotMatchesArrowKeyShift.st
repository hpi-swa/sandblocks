as yet unclassified
testNotMatchesArrowKeyShift

	self deny: (Character arrowLeft asSandblockShortcut matchesEvent: (KeyboardEvent new setType: #keyDown buttons: 8 position: 0 @ 0 keyValue: Character arrowLeft asInteger hand: nil stamp: 0))