*Sandblocks-Core-Simulate
simulateMouseUp

	| hand |
	hand := self activeHand.
	self mouseUp: (MouseButtonEvent new setType: #mouseUp position: self center which: 0 buttons: MouseEvent redButton hand: hand stamp: nil).
	hand releaseMouseFocus: self.
	self world ifNotNil: #doOneCycleNow