as yet unclassified
save

	| text newSelector |
	self allBlocksDo: [:block |
		block valid ifFalse: [self tryFix: block ifFail: [^ false]]].
	
	text := self prettySourceString.
	newSelector := self methodClass compile: text asText.
	(currentSelector ~= #'' and: [newSelector ~= currentSelector]) ifTrue: [
		self methodClass removeSelector: currentSelector].
	currentSelector := newSelector.
	
	self hasUnsavedChanges: false.
	^ true