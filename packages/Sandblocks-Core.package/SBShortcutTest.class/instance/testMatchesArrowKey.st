as yet unclassified
testMatchesArrowKey

	self assert: (Character arrowLeft asSandblockShortcut matchesEvent: (KeyboardEvent new setType: #keyDown buttons: 0 position: 0 @ 0 keyValue: Character arrowLeft asInteger hand: nil stamp: 0))