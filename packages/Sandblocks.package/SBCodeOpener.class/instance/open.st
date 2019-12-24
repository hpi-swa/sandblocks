as yet unclassified
open

	| hand world |
	" from DialogWindow>>getUserResponse "
	self openInWorld.
	hand := self currentHand.
	world := self currentWorld.
	
	hand showTemporaryCursor: nil.
	
	hand keyboardFocus in: [:priorKeyboardFocus |
		hand mouseFocus in: [:priorMouseFocus |
			hand newMouseFocus: self.
			hand newKeyboardFocus: self.
			
			[[self isInWorld] whileTrue: [world doOneSubCycle]]
				ifCurtailed: [self delete].
			
			hand newKeyboardFocus: priorKeyboardFocus.
			hand newMouseFocus: priorMouseFocus]].
	
	^ result