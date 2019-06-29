as yet unclassified
startInputAt: aNumber replacingContents: aBoolean

	^ currentCmd := SBInputToUnknownCommand new
		unknown: self;
		yourself