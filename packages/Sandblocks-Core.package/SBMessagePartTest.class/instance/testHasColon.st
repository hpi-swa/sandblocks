as yet unclassified
testHasColon

	| message |
	message := '5 yourself' parseAsSandblock.
	message selector: 'yourself' arguments: #().
	self deny: message messageParts first hasColon.
	message selector: 'yourself:' arguments: {SBUnknown new}.
	self assert: message messageParts first hasColon.
	message selector: '++' arguments: {SBUnknown new}.
	self deny: message messageParts first hasColon