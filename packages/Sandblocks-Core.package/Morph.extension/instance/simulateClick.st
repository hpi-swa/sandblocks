*Sandblocks-Core-Simulate
simulateClick

	| hand |
	hand := self activeHand.
	hand newMouseFocus: self.
	self click: (MouseButtonEvent new setType: #mouseUp position: self center which: 0 buttons: MouseEvent redButton hand: hand stamp: nil)