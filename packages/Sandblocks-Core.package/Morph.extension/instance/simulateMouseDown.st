*Sandblocks-Core-Simulate
simulateMouseDown

	| hand |
	hand := self activeHand.
	hand newMouseFocus: self.
	self mouseDown: (MouseButtonEvent new setType: #mouseDown position: self center which: 0 buttons: MouseEvent redButton hand: hand stamp: nil).
	self world doOneCycleNow