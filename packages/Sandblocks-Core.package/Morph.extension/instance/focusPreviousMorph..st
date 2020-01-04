*Sandblocks-Core
focusPreviousMorph: anEvent

	anEvent hand newKeyboardFocus: (self previousMorphThat: [:m | m wantsKeyboardFocus])