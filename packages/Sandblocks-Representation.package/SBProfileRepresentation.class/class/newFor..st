as yet unclassified
newFor: anObject


	anObject evaluate timeProfile.
	^ SBRepl new
		receiver: nil;
		statements: {
			(SBMessageSend new receiver: anObject selector: #timeProfile)
		}