as yet unclassified
testMatchesUpperCase

	self assert: ($O asSandblockShortcut matchesEvent: (KeyboardEvent new setType: #keyDown buttons: 8 position: 0 @ 0 keyValue: $O asInteger hand: nil stamp: 0))