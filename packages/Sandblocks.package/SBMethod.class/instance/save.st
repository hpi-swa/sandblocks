as yet unclassified
save

	| text |
	self allBlocksDo: [:block |
		block valid ifFalse: [self tryFix: block ifFail: [^ false]]].
	
	text := self prettySourceString.
	self methodClass compile: text asText.
	^ true