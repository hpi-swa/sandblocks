as yet unclassified
testMatchesColon

	self assert: ($: asSandblockShortcut matchesEvent: (KeyboardEvent new setType: #keyDown buttons: 8 position: 0 @ 0 keyValue: $: asInteger hand: nil stamp: 0))